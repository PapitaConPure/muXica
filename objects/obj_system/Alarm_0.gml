/// @description Play music
var _n = mux_arranger(aud_bgm_test1).params.n;
if _n == 1 {
	mux_sound_stop(aud_bgm_test1, 2000);
} else if _n == 2 {
	mux_sound_stop(aud_bgm_test1, 500);
	mux_sound_play(aud_bgm_test5, 40, true);
} else if _n == 3 {
	mux_sound_stop(aud_bgm_test1, 500);
	mux_sound_crossfade(1000, all, aud_bgm_test4, 99, true);
} else {
	mux_sound_play(aud_bgm_test2, 50, true);
}