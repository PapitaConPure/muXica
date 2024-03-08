/**
 * @param {String} message
 * @param {String} long_message
 */
function __mux_warn(message) {
	show_debug_message($"[!] muXica WARN: {message}");
}

#macro MUX_WARN_IF if MUX_WARN_ENABLE and 

#macro MUX_WARN_MARKER_DUPLICATED $"Marker \"{marker_name}\" already exists for arranger <{audio_get_name(self.index)}> in position: ${self.markers[$ _key].cue_point}s"

/**
 * @param {String} message
 * @param {String} long_message
 */
function __mux_ex(message, long_message = "No additional information was provided for this error") {
	throw {
		message: $"[!!!] muXica ERR: {message}",
		longMessage: long_message,
		stacktrace: debug_get_callstack()
	};
}

#macro MUX_EX_IF if MUX_EX_ENABLE and  

#macro MUX_EX_UNINITIALISED "Audio system wasn't initialised yet", "muXica worker didn't boot up on time to respond to the resquest"
#macro MUX_CHECK_UNINITIALISED ((MUX_HANDLER < 0) or not instance_exists(MUX_HANDLER))
#macro MUX_CHECK_UNINITIALISED_EX if MUX_CHECK_UNINITIALISED then __mux_ex(MUX_EX_UNINITIALISED)
#macro MUX_CHECK_UNINITIALISED_EX_OR_FALSE if MUX_CHECK_UNINITIALISED { if MUX_EX_ENABLE then __mux_ex(MUX_EX_UNINITIALISED) else return false; }

#macro MUX_EX_INVALID "Submitted audio was invalid", "Identifier is less than zero or isn't a valid audio asset or instance"
#macro MUX_CHECK_INVALID (MUX_EX_ENABLE and (index < 0) or not audio_exists(index))
#macro MUX_CHECK_INVALID_EX if MUX_CHECK_INVALID then __mux_ex(MUX_EX_INVALID)