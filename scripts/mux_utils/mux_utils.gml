/**
 * @pure
 * @param {String} str
 * @returns {String}
 */
function __mux_string_to_struct_key(str) {
	return string_replace_all(str, " ", "_");
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
