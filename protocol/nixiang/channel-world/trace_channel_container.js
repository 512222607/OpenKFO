'use strict';

const image = Process.getModuleByName('Client.exe');
const base = image.base;
// These globals are encoded as preferred-base absolute addresses in this PE.
// Unlike code RVAs, adding image.base again would point 0x10000 bytes too high.
const container = ptr('0x17C9424');

function count(map) {
  try { return map.add(28).readU32(); }
  catch (_) { return null; }
}

function bytes(address, size) {
  try { return Array.from(new Uint8Array(address.readByteArray(size))).map(x => x.toString(16).padStart(2, '0')).join(''); }
  catch (_) { return null; }
}

function offset(address) {
  return address.sub(base).toString();
}

function backtrace(context) {
  try {
    return Thread.backtrace(context, Backtracer.ACCURATE)
      .map(DebugSymbol.fromAddress)
      .map(String);
  } catch (_) {
    return [];
  }
}

function hook(relative, kind, callbacks) {
  Interceptor.attach(base.add(relative), Object.assign({
    onEnter(args) {
      this.map = this.context.ecx;
      this.before = count(this.map);
      this.caller = offset(this.returnAddress);
    },
    onLeave(retval) {
      send({kind, caller: this.caller, map: this.map.toString(), before: this.before, after: count(this.map)});
    }
  }, callbacks || {}));
}

hook(0x4DC110, 'channel-container-clear');
hook(0x4DBF40, 'channel-container-insert');

Interceptor.attach(base.add(0x904680), {
  onEnter(args) {
    let records = null;
    try { records = args[2].readU16(); } catch (_) {}
    this.records = records;
    send({kind: 'sdk-server-list-callback', ok: args[1].toInt32(), records, record_bytes: records === null ? null : bytes(args[2], Math.min(2 + records * 0x110, 0x400)), before: count(container), stack: backtrace(this.context)});
  },
  onLeave() { send({kind: 'sdk-server-list-return', records: this.records, after: count(container), container_head: bytes(container, 32)}); }
});

Interceptor.attach(base.add(0xA1BA90), {
  onEnter(args) {
    this.size = args[1].toUInt32();
    send({kind: 'channel-list26-callback', bytes: this.size, record_bytes: bytes(args[0], Math.min(this.size, 0x400)), before: count(container), stack: backtrace(this.context)});
  },
  onLeave() { send({kind: 'channel-list26-return', bytes: this.size, after: count(container)}); }
});

Interceptor.attach(base.add(0x812F00), {
  onEnter(args) {
    send({kind: 'handle-1201', value: args[0].readS32(), payload: bytes(args[0], 4)});
  }
});

Interceptor.attach(base.add(0x813160), {
  onEnter(args) {
    let size = null;
    try { size = args[1].toInt32(); } catch (_) {}
    send({kind: 'handle-2030', size, payload: size === null ? null : bytes(args[0], Math.min(size, 64))});
  }
});

Interceptor.attach(base.add(0x8FE7B0), {
  onEnter(args) {
    send({kind: 'choose-role-ui-event', event: args[0].toInt32(), control_arg: args[1].toString(), control_head: bytes(args[1], 32)});
  }
});

Interceptor.attach(base.add(0x8F95E0), {
  onEnter() {
    this.ui = this.context.ecx;
    send({kind: 'scan-selected-channel', ui: this.ui.toString(), slot_before: this.ui.add(0x584).readU8(), group_before: this.ui.add(0x588).readS32()});
  },
  onLeave(retval) {
    send({kind: 'scan-selected-channel-return', slot_after: this.ui.add(0x584).readU8(), group_after: this.ui.add(0x588).readS32(), retval: retval.toString()});
  }
});

Interceptor.attach(base.add(0x8F6180), {
  onEnter() { send({kind: 'send-role-select-3320-helper'}); }
});

Interceptor.attach(base.add(0xA2C950), {
  onEnter(args) {
    const messageId = args[0].toUInt32();
    if (messageId === 3320 || messageId === 2010)
      send({kind: 'game-message-send', message_id: messageId, payload_size: args[3].toUInt32(), payload: bytes(args[2], Math.min(args[3].toUInt32(), 64))});
  }
});

Interceptor.attach(base.add(0x8F7870), {
  onEnter() {
    const ui = this.context.ecx;
    send({kind: 'advance-selected-channel', ui: ui.toString(), slot: ui.add(0x584).readU8(), group: ui.add(0x588).readS32(), channel_count: count(container)});
  }
});

Interceptor.attach(base.add(0x900C00), {
  onEnter(args) {
    this.slot = args[0].toUInt32() & 0xff;
    this.group = args[1].toInt32();
    send({kind: 'connect-selected-channel', slot: this.slot, group: this.group, manager: this.context.ecx.toString(), channel_count: count(container)});
  },
  onLeave(retval) { send({kind: 'connect-selected-channel-return', slot: this.slot, group: this.group, retval: retval.toString()}); }
});

Interceptor.attach(base.add(0x900510), {
  onEnter(args) {
    let host = null;
    try { host = args[0].readCString(); } catch (_) {}
    send({kind: 'game-server-connect', host, port: args[1].toUInt32() & 0xffff, id1: args[2].toUInt32(), id2: args[3].toUInt32(), mode2010: args[4].toInt32()});
  }
});

send({kind: 'ready', pid: Process.id, base: base.toString(), container: container.toString(), initial_count: count(container), container_head: bytes(container, 32)});
