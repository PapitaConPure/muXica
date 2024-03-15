#macro MUX_HANDLER mux_scope_global._struct.worker
#macro MUX_HANDLER_DEPTH 16002

#macro MUX_GROUPS mux_handler_get_group
#macro MUX_BGM    mux_handler_get_group("BGM")
#macro MUX_SFX    mux_handler_get_group("SFX")
#macro MUX_ALL    mux_handler_get_group("all")
#macro MUX_P_STOP MUX_HANDLER.pending_sounds_stop
#macro MUX_P_FADE MUX_HANDLER.pending_sounds_crossfade

#macro MUX_ARRANGERS mux_scope_global._struct.arrangers
#macro MUX_CUES mux_scope_global._struct.cues
#macro MUX_TAGS mux_scope_global._struct.tags

#macro MUX_LOG_INFO if MUX_SHOW_LOG_INFO then show_debug_message
#macro MUX_LOG_STEP if MUX_SHOW_LOG_STEP then show_debug_message

/**
 * @param {String} group_name
 * @returns {Struct.MuxGroup}
 */
function mux_handler_get_group(group_name) {
	static _handler = MUX_HANDLER;
	return _handler.mux_sounds[$ group_name];
}

//Generate muXica global scope
mux_scope_global();
time_source_start(mux_scope_global._struct.ts_boot);

//Apply configs
mux_config_arrangers();
mux_config_cues();
mux_config_tags();
