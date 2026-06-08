(() => {
  const MR_PORT = '7126';
  const WS_URL = `${location.protocol === 'https:' ? 'wss' : 'ws'}://${location.hostname}:${MR_PORT}/websocket`;

  let ws = null;
  let reqId = 1;
  let connected = false;
  const pending = new Map();

  const $ = (sel) => document.querySelector(sel);
  const connPill = $('#conn-pill');
  const klipperState = $('#klipper-state');
  const mcuState = $('#mcu-state');
  const sensorState = $('#sensor-state');
  const consoleEl = $('#console');
  const nodeSensor = $('#node-sensor');
  const nodeA = $('#node-a');
  const nodeB = $('#node-b');

  function log(text, cls = 'sys') {
    const line = document.createElement('div');
    line.className = `line ${cls}`;
    line.textContent = `[${new Date().toLocaleTimeString('da-DK')}] ${text}`;
    consoleEl.appendChild(line);
    consoleEl.scrollTop = consoleEl.scrollHeight;
  }

  function setConn(state) {
    connPill.className = `pill pill-${state}`;
    connPill.textContent = state === 'ready' ? 'Klar' : state === 'online' ? 'Forbundet' : 'Offline';
  }

  function rpc(method, params = {}) {
    return new Promise((resolve, reject) => {
      if (!ws || ws.readyState !== WebSocket.OPEN) {
        reject(new Error('Ikke forbundet'));
        return;
      }
      const id = reqId++;
      pending.set(id, { resolve, reject });
      ws.send(JSON.stringify({ jsonrpc: '2.0', method, params, id }));
    });
  }

  function updateUI(status) {
    const state = status?.print_stats?.state || status?.webhooks?.state || 'unknown';
    const msg = status?.webhooks?.state_message || '';

    klipperState.textContent = state;
    klipperState.className = `stat-value ${state === 'ready' ? 'ok' : state === 'error' ? 'err' : ''}`;

    const mcu = status?.mcu?.mcu_version;
    mcuState.textContent = mcu ? 'Forbundet' : '—';
    mcuState.className = `stat-value ${mcu ? 'ok' : ''}`;

    const sensor = status?.['filament_switch_sensor sensor_downstream'];
    if (sensor) {
      const ok = sensor.filament_detected;
      sensorState.textContent = ok ? 'Filament OK' : 'Runout / tom';
      sensorState.className = `stat-value ${ok ? 'ok' : 'warn'}`;
      nodeSensor.classList.toggle('sensor-ok', ok);
      nodeSensor.classList.toggle('sensor-empty', !ok);
    }

    const vars = status?.['gcode_macro _FEEDER_VARS'];
    if (vars) {
      $('#var-retract').textContent = `${vars.retract_dist} mm`;
      $('#var-load').textContent = `${vars.load_dist} mm`;
      $('#var-purge').textContent = `${vars.purge_mm} mm`;
      $('#var-purge-speed').textContent = `${vars.purge_speed} mm/min`;
    }

    if (state === 'ready') setConn('ready');
    if (msg && msg !== 'Printer is ready') log(msg, 'echo');
  }

  async function subscribe() {
    await rpc('printer.objects.subscribe', {
      objects: {
        webhooks: null,
        print_stats: null,
        mcu: ['mcu_version'],
        'filament_switch_sensor sensor_downstream': ['filament_detected', 'enabled'],
        'gcode_macro _FEEDER_VARS': ['retract_dist', 'load_dist', 'purge_mm', 'purge_speed'],
      },
    });
  }

  async function runMacro(name) {
    log(`Kører: ${name}`, 'echo');
    await rpc('printer.gcode.script', { script: name });
  }

  function connect() {
    ws = new WebSocket(WS_URL);

    ws.onopen = async () => {
      connected = true;
      setConn('online');
      log('Forbundet til Moonraker', 'sys');
      try {
        const info = await rpc('server.info');
        log(`Moonraker ${info.version} · Klipper ${info.klipper_version}`, 'sys');
        await subscribe();
        const state = await rpc('printer.objects.query', {
          objects: { webhooks: null, print_stats: null },
        });
        updateUI(state.status);
      } catch (e) {
        log(`Fejl: ${e.message}`, 'error');
      }
    };

    ws.onmessage = (ev) => {
      const data = JSON.parse(ev.data);
      if (data.id && pending.has(data.id)) {
        const { resolve, reject } = pending.get(data.id);
        pending.delete(data.id);
        if (data.error) reject(new Error(data.error.message));
        else resolve(data.result);
        return;
      }
      if (data.method === 'notify_status_update') {
        updateUI(data.params[0]);
      }
      if (data.method === 'notify_gcode_response') {
        log(data.params[0], 'echo');
      }
      if (data.method === 'notify_klippy_shutdown') {
        log('Klipper shutdown', 'error');
        setConn('offline');
      }
      if (data.method === 'notify_klippy_ready') {
        log('Klipper klar', 'sys');
        setConn('ready');
      }
    };

    ws.onclose = () => {
      connected = false;
      setConn('offline');
      log('Forbindelse tabt – genforbinder om 3s', 'error');
      setTimeout(connect, 3000);
    };

    ws.onerror = () => log('WebSocket fejl', 'error');
  }

  document.querySelectorAll('[data-macro]').forEach((btn) => {
    btn.addEventListener('click', async () => {
      btn.disabled = true;
      try {
        await runMacro(btn.dataset.macro);
      } catch (e) {
        log(e.message, 'error');
      } finally {
        btn.disabled = false;
      }
    });
  });

  $('#gcode-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    const input = $('#gcode-input');
    const cmd = input.value.trim();
    if (!cmd) return;
    input.value = '';
    try {
      await rpc('printer.gcode.script', { script: cmd });
      log(`> ${cmd}`, 'echo');
    } catch (err) {
      log(err.message, 'error');
    }
  });

  const mainsailLink = $('#mainsail-link');
  if (mainsailLink) {
    const host = location.hostname;
    mainsailLink.href = `http://${host}:8082/`;
  }

  connect();
})();
