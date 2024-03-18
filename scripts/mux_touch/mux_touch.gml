//feather ignore all

/**
 * @desc Makes this instance wait until audio groups are loaded to then trigger the specified user event
 * @param {Real} user_event_n The event to execute when the audio groups finish loading
 */
function mux_touch(user_event_n) {
	if MUX_CHECK_UNINITIALISED {
		var _ts = time_source_create(time_source_global, 2, time_source_units_frames, __mux_connect_touch, [ id, user_event_n ]);
		time_source_start(_ts);
	} else {
		__mux_connect_touch(id, user_event_n);
	}
}

function __mux_connect_touch(id, n) {
	if MUX_HANDLER.audio_loaded {
		event_user(n);
		return;
	}
	
	ds_queue_enqueue(MUX_HANDLER.pending_instances_notify, { id, n });
}
