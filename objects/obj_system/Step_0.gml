/// @description Insert description here
var _test1 = mux_sound_is_playing(aud_bgm_test1);
var _test2 = mux_sound_is_playing("boss music");
var _test3 = mux_sound_is_playing(all);
var _test4 = sound >= 0 and mux_sound_is_playing(sound);

if current_time % 500 == 0 {
	show_debug_message($"{_test1}, {_test2}, {_test3}, {_test4}")
}
