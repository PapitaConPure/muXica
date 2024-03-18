//feather ignore all

/**
 * @desc Sets the position of the audio track to its cue position denoted by the specified name
 * @param {Asset.GMSound|Id.Sound} audio Audio index
 * @param {String} name Cue name
 */
function mux_cue_follow(sound, name) {
	var __cues = struct_get(MUX_CUES, audio);
	var __cue = __cues[$ name];
		
	MUX_EX_IF ((sound < 0) or not audio_exists(sound)) then __mux_ex(MUX_EX_INVALID);
	
	audio_sound_set_track_position(sound, __cue);
}
