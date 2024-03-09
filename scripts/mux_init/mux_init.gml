#macro MUX_HANDLER mux_scope_get().worker
#macro MUX_HANDLER_DEPTH 16002

#macro MUX_GROUPS    MUX_HANDLER.mux_sounds
#macro MUX_BGM       MUX_HANDLER.mux_sounds.BGM
#macro MUX_SFX       MUX_HANDLER.mux_sounds.SFX
#macro MUX_ALL       MUX_HANDLER.mux_sounds[$ "all"]
#macro MUX_P_STOP    MUX_HANDLER.pending_sounds_stop
#macro MUX_P_FADE    MUX_HANDLER.pending_sounds_crossfade

#macro MUX_ARRANGERS mux_scope_get().arrangers
#macro MUX_CUES mux_scope_get().cues
#macro MUX_TAGS mux_scope_get().tags

time_source_start(mux_scope_get().ts_boot);
