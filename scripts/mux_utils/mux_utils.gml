/**
 * @pure
 * @param {String} str
 * @returns {String}
 */
function __mux_string_to_struct_key(str) {
	return string_replace_all(str, " ", "_");
}

/**
 * @desc
 * @param {Real} bpm The bar's beats per minute
 * @param {Real} bar_beats The bar's beats
 * @param {Real} bar_note_value The bar's beat time note value. 4 is a quarter, 8 is an eight
 */
function __mux_time_bar_to_seconds(bpm, bar_beats, bar_note_value) {
	var _four_ratio = 4 * bar_beats / bar_note_value;
	return time_bpm_to_seconds(bpm) * _four_ratio;
}
