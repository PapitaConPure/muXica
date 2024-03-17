/**
 * @desc 
 * @param {Asset.GMAudioGroup} group Audio group to evaluate
 * @param {Real} gain Individual sound gain factor (defaults to 1)
 */
function mux_group_get_gain(group, gain = 1) {
	return audio_group_get_gain(group) * gain;
}

