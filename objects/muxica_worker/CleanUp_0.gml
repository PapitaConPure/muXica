struct_foreach(MUX_ARRANGERS, function(_, arranger) { arranger.free() });

ds_queue_destroy(pending_sounds_crossfade);
ds_queue_destroy(pending_instances_notify);
audio_group_stop_all(BGM);
audio_group_stop_all(SFX);
audio_group_unload(BGM);
audio_group_unload(SFX);
audio_loaded = false;

MUX_LOG_INFO("- - muXica worker has been terminated. All associated resources were freed up - -");
