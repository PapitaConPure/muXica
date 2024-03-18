/// @description On muXica load...
alarm[0] = game_get_speed(gamespeed_fps) * 3;

sys_emit = mux_emitter_create("BGM");
mux_sound_play(aud_bgm_test1, 9, true);
//mux_sound_play_on(sys_emit, aud_bgm_test1, 9, true);
