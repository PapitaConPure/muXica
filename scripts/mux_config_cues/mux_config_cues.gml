//Basic cue structuration
global.__mux_cues = {};
#macro MUX_CUES global.__mux_cues

//Use this section to design the audio cues muXica will know about during runtime
//
//
mux_cue_set(aud_bgm_test1, "intro",        0);
mux_cue_set(aud_bgm_test1, "verse1 start", 0);
mux_cue_set(aud_bgm_test1, "verse2 end",   0);
mux_cue_set(aud_bgm_test1, "verse2 start", 0);
mux_cue_set(aud_bgm_test1, "verse3 end",   0);