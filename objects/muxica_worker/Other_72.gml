/// @description Finish boot up
var _bgm_ready = (not MUX_GROUP_ACTIVE_BGM) || audio_group_is_loaded(BGM);
var _sfx_ready = (not MUX_GROUP_ACTIVE_SFX) || audio_group_is_loaded(SFX);

if _bgm_ready and _sfx_ready and !audio_loaded {
	mux_config_tags();
	mux_config_cues();
	mux_config_arrangers(); 

	audio_loaded = true;
	audio_groups_update();
	
	var _request;
	while not ds_queue_empty(mux_pending_instances) {
		_request = ds_queue_dequeue(mux_pending_instances);
		with _request.id event_user(_request.n);
	}
}