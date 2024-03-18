//Use this to create MuxArrangers for certain sound assets.
//MuxArrangers allow muXica to dinamically react to arbitrary cue events within active audio tracks.
//
//This includes, but is not limited to:
// * "if marker A is reached, then go to marker B"
// * "if marker A is reached and X is fulfilled, then go to marker B"
// * "After marker A, do X every Y beats"
// * etc...
//
//This is the somewhat more complex, but also more flexible alternative to using standalone cues.
//
//If you want to use standalone cues instead and follow them manually with your own systems,
//then go to mux_config_cues

function mux_config_arrangers() {
	//Initialize an arrangers batch
	mux_arrangers_init();
	
	
	//////////////////////////////////////////////////////////////////////////
	
	
	//You can design your own muXica sound arrangers here...
	
	/*mux_arranger_add(
		new MuxArranger(aud_bgm_test1, 144, { n: 1 })
		.set_bpm(143)
		.set_time_signature(4, 4)
		.jump_bars(1)
		.set_marker("to middle", new MuxJumpMarker(
			function(params) { return true; },
			"loop mid 1"))
		.jump_bars(16)
		.set_marker_repeat("loop middle", 1, MUX_MRK_UNIT.BARS, 1, new MuxEventMarker(
			function(marker, sound, offset, params) {
				if params.n == 2 then mux_sound_play(aud_sfx_test1, 5, false, 1, 0.011);
			}))
		.jump_bars(4)
		.set_marker("loop end", new MuxJumpMarker(
			function(params) { return params.n != 4; },
			"loop middle 1"))
		.set_marker("loop break", new MuxJumpMarker(
			function(params) { return params.n == 4; },
			"big jump"))
		.jump_bars(30)
		.set_marker("big jump", new MuxMarker())
	);*/
	
	
	//////////////////////////////////////////////////////////////////////////
	
	
	//Submit the batch with all the arrangers
	mux_arrangers_submit();
}
