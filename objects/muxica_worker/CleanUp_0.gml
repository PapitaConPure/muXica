ds_list_destroy(mux_sounds.BGM);
ds_list_destroy(mux_sounds.SFX);
ds_list_destroy(mux_sounds[$ "all"]);

struct_foreach(MUX_ARRANGERS, function(_, arranger) { arranger.free() });

ds_list_destroy(pending_sounds_stop);
ds_queue_destroy(pending_sounds_crossfade);
ds_queue_destroy(pending_instances_notify);
audio_group_stop_all(BGM);
audio_group_stop_all(SFX);
audio_group_unload(BGM);
audio_group_unload(SFX);
audio_loaded = false;

if MUX_SHOW_LOG_INFO then show_debug_message("- - Se liberaron los recursos del sistema de audio - -");
