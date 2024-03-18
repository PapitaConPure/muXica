//feather ignore all

MUX_LOG_INFO("- -  - -");

mux_sounds = {
	"all": new MuxBank("all", audio_bus_main),
};

//Pending tasks
pending_sounds_stop = new MuxBank("stop"); //Sounds need more than being on this list to be deleted
pending_sounds_crossfade = ds_queue_create();
pending_instances_notify = ds_queue_create();

//Crossfade pseudo-alarms that can run in parallel up to a user-defined amount
timer_crossfade = array_create(MUX_CROSSFADE_PARALLEL_LIMIT, -1);
timer_crossfade_n = 0;

MUX_HANDLER = id;
persistent = true;    
depth = MUX_HANDLER_DEPTH;
MUX_LOG_INFO("- - muXica worker UP. Loading muXica audio groups... - -");
audio_loaded = false;
mux_config_banks();

alarm[0] = 2;
