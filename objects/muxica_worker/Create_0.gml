mux_sounds = {
	BGM: ds_list_create(),
	SFX: ds_list_create(),
	"all": ds_list_create()
};

mux_sounds_stop_pending = ds_list_create();
mux_sounds_fadein_pending = ds_queue_create();

//Probably unnecessary, but I did what I had to do
timer_crossfade = array_create(16, -1);
timer_crossfade_n = 0;

mux_pending_instances = ds_queue_create();

audio_loaded = false;
audio_group_load(BGM);
audio_group_load(SFX);

if MUX_SHOW_LOG_INFO then show_debug_message("- - Se inicializó un sistema de audio - -");
