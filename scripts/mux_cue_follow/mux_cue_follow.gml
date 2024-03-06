/**
 * @description Sets the position of the audio track to its cue position denoted by the specified name
 * @param {Asset.GMSound} audio Audio index
 * @param {String} name Cue name
 * @param {Id.Sound} [sound]=undefined Sound id
 */
function mux_cue_follow(audio, name, sound = undefined) {
	var __cues = struct_get(MUX_CUES, audio);
	var __cue = __cues[$ name];
		
	if(is_undefined(sound))
		audio_sound_set_track_position(audio, __cue);
	else
		audio_sound_set_track_position(sound, __cue);
}
