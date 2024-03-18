///@desc Returns the audio position in seconds, based on the specified beat number, BPM, and initial offset
///@param {Real} [n] Beat number (0 by default)
///@param {Real} [bpm] Beats per minute (140 by default)
///@param {Real} [offset] First beat offset (in seconds) (0.1 by default)
function mux_time_get_beat_pos(n, bpm = 140, offset = 0.1) {
	return offset + time_bpm_to_seconds(bpm) * n;
}

///@desc Returns the audio position in seconds, based on the specified bar number, BPM, time signature (bar_beats / bar_note_value), and initial offset
///@param {Real} [n] Bar number
///@param {Real} [bpm] Beats per minute (140 by default)
///@param {Real} [offset] First beat offset (in seconds) (0.1 by default)
function mux_time_get_bar_pos(n, bpm = 140, bar_beats = 4, bar_note_value = 4, offset = 0.1) {
	return offset + mux_time_bar_to_seconds(bpm, bar_beats, bar_note_value) * n;
}

/**
 * @desc Returns the duration of a bar in seconds, based on the specified BPM and time signature (bar_beats / bar_note_value)
 * @param {Real} bpm The bar's beats per minute
 * @param {Real} bar_beats The bar's beats
 * @param {Real} bar_note_value The bar's beat time note value. 4 is a quarter, 8 is an eight
 */
function mux_time_bar_to_seconds(bpm, bar_beats, bar_note_value) {
	var _four_ratio = 4 * bar_beats / bar_note_value;
	return time_bpm_to_seconds(bpm) * _four_ratio;
}
