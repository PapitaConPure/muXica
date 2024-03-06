/// @param {Asset.GMSound} sound_index
/// @param {Real} priority
/// @param {Bool} loop
function audio_group_set_stop_all(sound_index) {
	MUX_CHECK_UNINITIALISED_EX
	
	var _id = audio_play_sound(sound_index, priority, loop);
	var _group_idx = audio_sound_get_audio_group(sound_index);
	audio_group_stop_all(_group_idx);
	var _group_key = audio_group_name(_group_idx);
	ds_list_add(MUX_GROUPS[$ _group_key], new MuxSound(sound_index, _id));
}