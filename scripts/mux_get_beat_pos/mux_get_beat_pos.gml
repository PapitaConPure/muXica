///@desc Returns the audio position in seconds, based on the beat, bpm and initial offset
///@param {Real} [n]=0 Beat number
///@param {Real} [bpm]=140 Beats per minute
///@param {Real} [offset]=0.1 First beat offset (in seconds)
function mux_get_beat_pos(n = 0, bpm = 140, offset = 0.1) {
	return offset + time_bpm_to_seconds(bpm) * n;
}