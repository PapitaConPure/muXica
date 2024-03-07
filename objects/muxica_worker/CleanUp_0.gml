ds_list_destroy(mux_sounds.BGM);
ds_list_destroy(mux_sounds.SFX);
ds_list_destroy(mux_sounds[$ "all"]);

struct_foreach(mux_arrangers, function(_, arranger) { arranger.free() });

ds_list_destroy(mux_sounds_stop_pending);
ds_queue_destroy(mux_sounds_fadein_pending);
ds_queue_destroy(mux_pending_instances);
audio_group_stop_all(BGM);
audio_group_stop_all(SFX);
audio_group_unload(BGM);
audio_group_unload(SFX);
audio_loaded = false;

if MUX_SHOW_LOG_INFO then show_debug_message("- - Se liberaron los recursos del sistema de audio - -");
