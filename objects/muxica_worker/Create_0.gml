mux_sounds = {
	BGM: ds_list_create(),
	SFX: ds_list_create(),
	"all": ds_list_create()
};

//Pending tasks
pending_sounds_stop = ds_list_create(); //Sounds need more than being on this list to be deleted
pending_sounds_crossfade = ds_queue_create();
pending_instances_notify = ds_queue_create();

//Crossfade pseudo-alarms that can run in parallel up to a user-defined amount
timer_crossfade = array_create(MUX_CROSSFADE_PARALLEL_LIMIT, -1);
timer_crossfade_n = 0;

audio_loaded = false;
audio_group_load(BGM);
audio_group_load(SFX);

if MUX_SHOW_LOG_INFO then show_debug_message("- - Se inicializó un sistema de audio - -");
