enum MUX_ARR_F {
	NAME,
	STRUCT,
}

///@desc Must be called once to generate the global scope for the muXica system. This should already be achieved inside the mux_init script
function mux_scope_global() {
	static _struct = {
		worker: noone,
		ts_boot: time_source_create(time_source_global, 1, time_source_units_frames, mux_persist, [], -1),
		default_emitter: {
			falloff: {
				distance_reference: 100_000_000,
				distance_maximum: 100_000_000,
				factor: 0
			},
			gain: 1,
			pitch: 1,
			position: [ 0, 0, 0 ],
			velocity: [ 0, 0, 0 ],
			listener_mask: 1
		},
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