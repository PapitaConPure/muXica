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

/**
 * @desc Wraps a value endlessly within the specified range
 * @param {Real} value The value to wrap within a range
 * @param {Real} vmin The wrap range's minimum value. Must be greater than vmax
 * @param {Real} vmax The wrap range's maximum value. Must be lesser than vmin
 * @param {Bool} [max_exclusive]=false Whether to exclude the maximum value from the range (true) or not (false)
 */
function __mux_wrap(value, vmin, vmax, max_exclusive = false) {
	if value < vmin then return vmin + abs(value % (vmax - vmin)) * sign(value);
	if value > vmax or (max_exclusive and value == vmax) then return vmin + value % (vmax - vmin);
	return value;
}

/**
 * @desc Returns a value that waves between "a" and "b" over the specified duration in seconds
 * @param {Real} a First extreme
 * @param {Real} b Second extreme
 * @param {Real} [duration]=1 Oscillation duration
 * @param {Real} [offset]=0 Wave offset, in a full-cycle percentage from 0.0 to 1.0 (can extrapolate)
 */
function wave(a, b, duration = 1, offset = 0) {
	var _half = (b - a) * 0.5;
	return a + _half + sin((current_time * 0.001 / duration + offset) * TAU) * _half;
}
