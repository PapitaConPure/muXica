/**
 * @pure
 * @param {String} str
 * @returns {String}
 */
function __mux_string_to_struct_key(str) {
	return string_replace(str, " ", "_");
}