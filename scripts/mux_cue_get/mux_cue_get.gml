//feather ignore all

/**
 * @desc Gets the track position of the specified audio cue
 * @param {Asset.GMSound|Id.Sound} sound Audio asset index or sound instance
 * @param {String} name Cue name
 */
function mux_cue_get(sound, name = "intro") {
	var _sound_key = __mux_string_to_struct_key(audio_get_name(sound));
	var _name_key = __mux_string_to_struct_key(name);
	var _cues = MUX_CUES[$ _sound_key];
	return _cues[$ _name_key];
}