/**
 * @desc Submits the indicated MuxArranger to the muXica handler
 * @param {Struct.MuxArranger} arranger The MuxArranger instance to submit
 */
function mux_arranger_set(arranger) {
	var _key = audio_get_name(arranger.index);
	MUX_ARRANGERS[$ _key] = arranger;
}
/**
 * @desc Submits the indicated MuxArranger to the muXica handler
 * @param {Array<Struct.MuxArranger>} arrangers The MuxArranger instances to submit
 */
function mux_arranger_set_batch(arrangers) {
	MUX_EX_IF not is_array(arrangers) then __mux_ex("Invalid type", "Expected type Array<Struct.MuxArranger>");
	
	var _l = array_length(arrangers);
	var _i = 0;
	var _a, _key;
	repeat _l {
		_a = arrangers[_i++];
		_key = audio_get_name(_a.index);
		MUX_ARRANGERS[$ _key] = _a;
	}
}
