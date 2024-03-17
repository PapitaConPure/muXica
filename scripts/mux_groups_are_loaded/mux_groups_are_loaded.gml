//feather disable all

/**
 * @desc Checks whether all audio groups for the registered muXica sound banks were loaded (true) or not (false)
 */
function mux_groups_are_loaded() {
	return array_all(MUX_GLOBAL.loaded_groups, audio_group_is_loaded);
}
