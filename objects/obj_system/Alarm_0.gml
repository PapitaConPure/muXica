/// @desc Play music
/*if mux_sound_any_is_paused(aud_bgm_test1)
	mux_sound_resume(aud_bgm_test1);
else
	mux_sound_pause(aud_bgm_test1);*/

//mux_sound_play(aud_bgm_test2, 99, true);
//mux_sound_play_on(sys_emit, aud_bgm_test2, 99, true);

alarm[0] = game_get_speed(gamespeed_fps) * 6;

if mux_sound_any_is_playing(aud_bgm_test1) {
	sound = mux_sound_crossfade(1, aud_bgm_test1, aud_bgm_test5, 50);
} else if mux_sound_any_is_playing("boss music") {
	mux_sound_crossfade(1.5, "boss music", aud_bgm_test4, 60);
} else if mux_sound_any_is_playing() and not mux_sound_is_playing(sound) {
	sound = mux_sound_crossfade(0.5, all, aud_bgm_test3, 60);
} else {
	alarm[0] = -1;
}
	