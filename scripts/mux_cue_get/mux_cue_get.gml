/**
 * @desc Description
 * @param {Asset.GMSound} audio Audio index
 * @param {String} name Cue name
 */
function audio_cue_get(audio, name = "intro") {
	var __cues = MUX_CUES[$ audio];
	return __cues.get_cue(name);
}