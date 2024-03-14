MUX_LOG_INFO("- -  - -");

mux_sounds = {
	BGM: new MuxGroup("BGM"),
	SFX: new MuxGroup("SFX"),
	"all": new MuxGroup("all")
};

//Pending tasks
pending_sounds_stop = new MuxGroup("stop"); //Sounds need more than being on this list to be deleted
pending_sounds_crossfade = ds_queue_create();
pending_instances_notify = ds_queue_create();

//Crossfade pseudo-alarms that can run in parallel up to a user-defined amount
timer_crossfade = array_create(MUX_CROSSFADE_PARALLEL_LIMIT, -1);
timer_crossfade_n = 0;

MUX_LOG_INFO("- - muXica worker UP. Loading muXica audio groups... - -");
audio_loaded = false;
audio_group_load(BGM);
audio_group_load(SFX);
