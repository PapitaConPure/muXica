var _arrangers = MUX_ARRANGERS;
var _ww = ds_grid_width(_arrangers);
var _hh = ds_grid_height(_arrangers);
var _xx, _yy;
for(_xx = 0; _xx < _ww; _xx++) {
	for(_yy = 0; _yy < _hh; _yy++) {
		ds_grid_get(_arrangers, _xx, _yy).free();
	}
}

ds_queue_destroy(pending_sounds_crossfade);
ds_queue_destroy(pending_instances_notify);
audio_group_stop_all(BGM);
audio_group_stop_all(SFX);
audio_group_unload(BGM);
audio_group_unload(SFX);
audio_loaded = false;

MUX_LOG_INFO("- - muXica worker has been terminated. All associated resources were freed up - -");
