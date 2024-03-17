//feather disable all

/**
 * @desc Loads all audio groups that have been associated to a registered muXica sound bank
 * 
 */
function mux_group_load_all() {
	array_foreach(MUX_GLOBAL.loaded_groups, function(group) {
		audio_group_load(group);
	});
}