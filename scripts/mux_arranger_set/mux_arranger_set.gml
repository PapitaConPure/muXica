///@desc Initializes a MuxArranger batch for later submission
function mux_arrangers_init() {
	static config_arrangers = [];
}

/**
 * @desc Adds the indicated MuxArranger to the MuxArranger batch to submit
 * @param {Struct.MuxArranger} arranger The MuxArranger instance to add
 */
function mux_arranger_add(arranger) {
	var _name = audio_get_name(arranger.index);
	array_push(mux_arrangers_init.config_arrangers, [ _name, arranger ]);
}

///@desc Submits the indicated MuxArranger batch to the muXica handler
function mux_arrangers_submit() {
	var _array = mux_arrangers_init.config_arrangers;
	var _length = array_length(_array);
	var _name, _arranger;
	
	mux_scope_global._struct.arrangers = ds_grid_create(_length, 2);
	for(var _row = 0; _row < _length; _row++) {
		_name = _array[_row][MUX_ARR_F.NAME];
		_arranger = _array[_row][MUX_ARR_F.STRUCT];
		ds_grid_add(MUX_ARRANGERS, _row, MUX_ARR_F.NAME, _name);
		ds_grid_add(MUX_ARRANGERS, _row, MUX_ARR_F.STRUCT, _arranger);
		_arranger.finalize_markers();
	}
	
	mux_arrangers_init.config_arrangers = [];
}
