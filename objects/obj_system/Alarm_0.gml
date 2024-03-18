/// @description Play music
if mux_sound_any_is_paused(aud_bgm_test1)
	mux_sound_resume(aud_bgm_test1);
else
	mux_sound_pause(aud_bgm_test1);

audio_emitter_pitch(sys_emit, 1.5);
//mux_sound_play(aud_bgm_test2, 99, true);
mux_sound_play_on(sys_emit, aud_bgm_test2, 99, true);
