//feather ignore all

/**
 * @desc Checks if the audio system is ready to be processed and used (true) or not (false)
 * @returns {Bool}
 */
function mux_is_ready() {
	return not MUX_CHECK_UNINITIALISED
	   and MUX_HANDLER.audio_loaded
	   and audio_system_is_initialised()
	   and audio_system_is_available();
}
