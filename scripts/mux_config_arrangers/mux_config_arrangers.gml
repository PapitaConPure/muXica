//Use this to create MuxArrangers for certain sound assets.
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

function mux_config_arrangers() {
	mux_arrangers_init();
	
	mux_arranger_add(
		new MuxArranger(aud_bgm_test1, 144, { n: 1 })
		.set_bpm(143)
		.set_time_signature(4, 4)
		.jump_bars(1)
		.set_marker("to start", new MuxJumpMarker(
			function(params) { return true; },
			"loop start 1"))
		.jump_bars(16)
		.set_marker_repeat("loop start", 1, MUX_MARKER_UNIT.BARS, 1, new MuxEventMarker(
			function(marker, sound, offset, params) {
				if params.n == 2 then mux_sound_play(aud_sfx_test1, 5, false, 1, 0.011);
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
		.set_marker_repeat("lol", 2, MUX_MARKER_UNIT.BEATS, 16, new MuxEventMarker(
			function(marker, sound, offset, params) {
				if params.n == 2 then mux_sound_play(aud_sfx_test1, 5, false, 1, 0.011);
			}))
		.jump_beats(2 * 16)
		.set_marker_repeat("lmao", 1, MUX_MARKER_UNIT.BEATS, 32, new MuxEventMarker(
			function(marker, sound, offset, params) {
				if params.n == 2 then mux_sound_play(aud_sfx_test1, 5, false, 1, 0.011);
			}))
	);
	
	mux_arranger_add(
		new MuxArranger(aud_bgm_test2, 80, { tension: 25, last_pos: -1 })
		.set_bpm(128)
		.set_time_signature(4, 4)
		.set_marker_repeat("switch to heavy", 2, MUX_MARKER_UNIT.BARS, 68, new MuxConditionMarker(
			function(params) { return params.tension > 50; },
			function(marker, sound, offset, params) {
				params.last_pos = marker.cue_point - offset;
				marker.follow_cue(sound, "heavy intro", offset, false);
			}))
		.jump_bars(1)
		.set_marker("to normal loop start", new MuxLoopMarker("normal loop start"))
		.jump_bars(67)
		.set_marker("normal loop start", new MuxEventMarker(
			function(marker, sound, offset, params) {
				if params.last_pos >= 0 {
					sound.set_track_position(marker.cue_point + params.last_pos - offset);
					params.last_pos = -1;
				}
			}))
		.jump_bars(68)
		.set_marker("normal loop", new MuxJumpMarker(
			function(params) {
				return params.tension < 50;
			},
			"normal loop start"))
		.jump_bars(2)
		.set_marker("offset normal", new MuxMarker())
		.jump_bars(1)
		.set_marker("heavy intro", new MuxMarker())
		.jump_bars(1)
		.set_marker("heavy start", new MuxEventMarker(
			function(marker, sound, offset, params) {
				if params.last_pos >= 0 {
					sound.set_track_position(marker.cue_point + params.last_pos - offset);
					params.last_pos = -1;
				}
			}))
		.set_marker_repeat("switch to normal", 2, MUX_MARKER_UNIT.BARS, 68, new MuxConditionMarker(
			function(params) { return params.tension <= 50; },
			function(marker, sound, offset, params) {
				params.last_pos = marker.cue_point - marker.handler.markers.offset_normal.cue_point - offset;
				marker.follow_cue(sound, "normal loop start", offset, false);
			}))
		.jump_bars(68 * 2)
		.set_marker("heavy loop", new MuxLoopMarker("heavy start"))
	);
	
	mux_arrangers_submit();
}
