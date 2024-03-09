/// @description Finish boot up
var _bgm_ready = (not MUX_GROUP_ACTIVE_BGM) || audio_group_is_loaded(BGM);
var _sfx_ready = (not MUX_GROUP_ACTIVE_SFX) || audio_group_is_loaded(SFX);

if _bgm_ready and _sfx_ready and !audio_loaded {
	mux_groups_update();
	
	audio_loaded = true;
	
	var _request;
	while not ds_queue_empty(pending_instances_notify) {
		_request = ds_queue_dequeue(pending_instances_notify);
		with _request.id event_user(_request.n);
	}
}