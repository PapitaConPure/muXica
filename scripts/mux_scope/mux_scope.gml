function mux_scope_get() {
	static _global = {
		worker: noone,
		ts_boot: time_source_create(time_source_global, 1, time_source_units_frames, mux_persist, [], -1),
		arrangers: {},
		tags: {},
		cues: {},
	};
	return _global;
}

/**
 * @param {String} key
 * @param {Any} value
 */
function mux_scope_set(key, value) {
	static _global = mux_scope_get();
	_global[$ key] = value;
}