enum MUX_ARR_F {
	NAME,
	STRUCT,
}

///@desc Must be called once to generate the global scope for the muXica system. This should already be achieved inside the mux_init script
function mux_scope_global() {
	static _struct = {
		worker: noone,
		ts_boot: time_source_create(time_source_global, 1, time_source_units_frames, mux_persist, [], -1),
		default_emitter: audio_emitter_create(),
		sound_bank_index: {},
		loaded_groups: [],
		arrangers: undefined,
		cues: {},
		tags: {}
	};
	
	return _struct;
}

///@param {String} key
function mux_scope_get(key) {
	return mux_scope_global._struct;
}

/**
 * @param {String} key
 * @param {Any} value
 */
function mux_scope_set(key, value) {
	var _global = mux_scope_global._struct;
	_global[$ key] = value;
}