//feather ignore all

/**
 * @desc Sets the position of the audio track to its cue position denoted by the specified name
 * @param {Asset.GMSound|Id.Sound} audio Audio index
 * @param {String} name Cue name
 */
function mux_cue_follow(sound, name) {
	MUX_CHECK_INVALID_EX;
	
	var _sound_key = __mux_string_to_struct_key(audio_get_name(sound));
	var _name_key = __mux_string_to_struct_key(name);
	var _cues = MUX_CUES[$ _sound_key];
	var _cue = _cues[$ _name_key];
		
	audio_sound_set_track_position(sound, _cue);
}
