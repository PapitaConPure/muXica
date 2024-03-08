function mux_config_arrangers() {
	//Use this section to create MuxArrangers for certain sound assets.
	//MuxArrangers allow muXica to dinamically react to arbitrary cue events within active audio tracks.
	//
	//This includes, but is not limited to:
	// * "if marker A is reached, then go to marker B"
	// * "if marker A is reached and X is fulfilled, then go to marker B"
	// * "After marker A, do X every Y beats"
	// * etc...
	//
	//This is the somewhat harder, but more flexible alternative to using standalone cues.
	//
	//If you want to use standalone cues instead and follow them manually with your own systems,
	//then go to mux_config_cues

	mux_arranger_set_batch([
		new MuxArranger(aud_bgm_test1, 150, { n: 1 })
			.set_bpm(143)
			.set_time_signature(4, 4)
			.jump_bars(1)
			.set_marker("to start", new MuxJumpMarker(
				function(params) { return true; },
				"loop start 1"))
			.jump_bars(16)
			.set_marker_repeat("loop start", 1, MUX_MARKER_UNIT.BARS, 4, new MuxEventMarker(
				function(sound, offset, params) {
					audio_sound_set_track_position(audio_play_sound(aud_sfx_test1, 5, false), 0.01);
				}))
			.jump_bars(4)
			.set_marker("loop end", new MuxJumpMarker(
				function(params) { return params.n != 4; },
				"loop start 1"))
			.set_marker("loop break", new MuxJumpMarker(
				function(params) { return params.n == 4; },
				"cute"))
			.jump_bars(30)
			.set_marker("cute", new MuxMarker())
			.set_marker_repeat("lol", 2, MUX_MARKER_UNIT.BEATS, 16, new MuxConditionMarker(
				function(params) { return params.n == 2; },
				function(sound, offset, params) {
					show_debug_message("Task failed successfully");
					audio_sound_set_track_position(audio_play_sound(aud_sfx_test1, 5, false), 0.01);
				}))
			.jump_beats(2 * 16)
			.set_marker_repeat("lmao", 1, MUX_MARKER_UNIT.BEATS, 32, new MuxConditionMarker(
				function(params) { return params.n == 2; },
				function(sound, offset, params) {
					show_debug_message("Task failed successfully");
					audio_sound_set_track_position(audio_play_sound(aud_sfx_test1, 5, false), 0.01);
				}))
	]);
}
