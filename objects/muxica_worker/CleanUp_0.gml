audio_loaded = false;
ds_queue_destroy(pending_sounds_crossfade);
ds_queue_destroy(pending_instances_notify);
mux_group_unload_all();

MUX_LOG_INFO("- - muXica worker has been terminated. All associated resources were freed up - -");
