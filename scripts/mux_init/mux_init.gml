#region Macros
#macro MUX_GLOBAL mux_scope_global._struct
#macro MUX_HANDLER MUX_GLOBAL.worker
#macro MUX_HANDLER_DEPTH 16002

#macro MUX_DEFAULT_EMITTER MUX_GLOBAL.default_emitter

#macro MUX_BANKS MUX_HANDLER.mux_sounds
#macro MUX_ALL    mux_bank_get("all")
#macro MUX_P_STOP MUX_HANDLER.pending_sounds_stop
#macro MUX_P_FADE MUX_HANDLER.pending_sounds_crossfade

#macro MUX_ARRANGERS MUX_GLOBAL.arrangers
#macro MUX_CUES MUX_GLOBAL.cues
#macro MUX_TAGS MUX_GLOBAL.tags

#macro MUX_LOG_INFO if MUX_SHOW_LOG_INFO then show_debug_message
#macro MUX_LOG_STEP if MUX_SHOW_LOG_STEP then show_debug_message
#endregion

#region Enums
enum MUX_ARR_F {
	NAME,
	STRUCT,
}

enum MUX_MRK_UNIT {
	BEATS,
	BARS,
	SECONDS,
}

enum MUX_ODMK_F {
	NAME,
	STRUCT,
}
#endregion

#region System initialization
//Generate muXica global scope
mux_scope_global();
time_source_start(MUX_GLOBAL.ts_boot);

//Apply configs
mux_config_arrangers();
mux_config_cues();
mux_config_tags();
#endregion
