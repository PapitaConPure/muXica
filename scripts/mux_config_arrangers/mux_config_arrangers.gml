function mux_config_arrangers() {
	//Create MuxArrangers for the sounds you want to dinamically morph through cue events

	mux_arranger_set_batch([
		new MuxArranger(aud_bgm_test1, 150)
			.set_bpm(143)
			.jump(4)
			.set_marker("wa", new MuxConditionMarker(function(params) {
				return struct_exists(params, "n") and params.n == 1;
			}, function(offset, params) {
				audio_play_sound(aud_sfx_test1, 5, false);
			}))
			.jump(4)
			.set_marker("we", new MuxConditionMarker(function(params) {
				return struct_exists(params, "n") and params.n == 2;
			}, function(offset, params) {
				audio_play_sound(aud_sfx_test1, 5, false);
			}))
			.jump(4)
			.set_marker("wi", new MuxConditionMarker(function(params) {
				return struct_exists(params, "n") and params.n == 3;
			}, function(offset, params) {
				audio_play_sound(aud_sfx_test1, 5, false);
			}))
			.jump(4)
			.set_marker("wo", new MuxConditionMarker(function(params) {
				return struct_exists(params, "n") and params.n == 4;
			}, function(offset, params) {
				audio_play_sound(aud_sfx_test1, 5, false);
				show_message("wa");
			}))
	]);
}
