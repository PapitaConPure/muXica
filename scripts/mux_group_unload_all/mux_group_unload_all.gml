//feather disable all

/**
 * @desc Stops and unloads all audio groups that have been associated to a registered muXica sound bank
 */
function mux_group_unload_all() {
	array_foreach(MUX_GLOBAL.loaded_groups, function(group) {
		audio_group_stop_all(group);
		audio_group_unload(group);
	});
}