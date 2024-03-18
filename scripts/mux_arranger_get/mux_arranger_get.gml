//feather ignore all

/**
 * @desc Returns a sound arranger based on the provided sound asset index
 * @param {Asset.GMSound|Id.GMSound} index
 * @returns {Struct.MuxArranger}
 */
function mux_arranger_get(index) {
	var _name = audio_get_name(index);
	
	var _arrangers = MUX_ARRANGERS;
	var _index = ds_grid_value_x(_arrangers, 0, MUX_ARR_F.NAME, ds_grid_width(_arrangers) - 1, MUX_ARR_F.NAME, _name);
	
	return ds_grid_get(_arrangers, _index, MUX_ARR_F.STRUCT);
}
