//gml_pragma("global");

global.__mux_audio_worker_object = noone;
#macro MUX_HANDLER global.__mux_audio_worker_object
#macro MUX_HANDLER_DEPTH 16002

#macro MUX_GROUPS    MUX_HANDLER.mux_sounds
#macro MUX_BGM       MUX_HANDLER.mux_sounds.BGM
#macro MUX_SFX       MUX_HANDLER.mux_sounds.SFX
#macro MUX_ALL       MUX_HANDLER.mux_sounds[$ "all"]
#macro MUX_ARRANGERS MUX_HANDLER.mux_arrangers
#macro MUX_P_STOP    MUX_HANDLER.mux_sounds_stop_pending
#macro MUX_P_FADE    MUX_HANDLER.mux_sounds_fadein_pending

global.__mux_cues = {};
#macro MUX_CUES global.__mux_cues

global.__mux_boot_time_source = time_source_create(time_source_global, 1, time_source_units_frames, mux_tick, [], -1);
time_source_start(global.__mux_boot_time_source);
