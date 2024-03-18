//Use this to design the audio cues muXica will know about during runtime
//This is the easier alternative to using the more flexible MuxArrangers and MuxMarkers system

//Example cues for a particular audio...
function mux_config_cues() {
	mux_cue_set(aud_bgm_test1, "intro",        0);
	mux_cue_set(aud_bgm_test1, "verse1 start", mux_time_get_beat_pos(4, 148, 0.147));
	mux_cue_set(aud_bgm_test1, "verse2 end",   mux_time_get_beat_pos(8, 148, 0.147));
	mux_cue_set(aud_bgm_test1, "verse2 start", mux_time_get_beat_pos(12, 148, 0.147));
	mux_cue_set(aud_bgm_test1, "verse3 end",   mux_time_get_beat_pos(16, 148, 0.147));
}
