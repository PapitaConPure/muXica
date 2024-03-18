///@desc Returns the audio position in seconds, based on the beat, bpm and initial offset
///@param {Real} [n]=0 Beat number
///@param {Real} [bpm]=140 Beats per minute
///@param {Real} [offset]=0.1 First beat offset (in seconds)
function mux_time_get_beat_pos(n = 0, bpm = 140, offset = 0.1) {
	return offset + time_bpm_to_seconds(bpm) * n;
}

///@desc Returns the audio position in seconds, based on the beat, bpm and initial offset
///@param {Real} [n]=0 Bar number
///@param {Real} [bpm]=140 Beats per minute
///@param {Real} [offset]=0.1 First beat offset (in seconds)
function mux_time_get_beat_pos(n = 0, bpm = 140, offset = 0.1) {
	return offset + time_bpm_to_seconds(bpm) * n;
}

/**
 * @desc
 * @param {Real} bpm The bar's beats per minute
 * @param {Real} bar_beats The bar's beats
 * @param {Real} bar_note_value The bar's beat time note value. 4 is a quarter, 8 is an eight
 */
function mux_time_bar_to_seconds(bpm, bar_beats, bar_note_value) {
	var _four_ratio = 4 * bar_beats / bar_note_value;
	return time_bpm_to_seconds(bpm) * _four_ratio;
}