//feather ignore all

/**
 * @desc Links the supplied emitter to the bus from the bank specified by name.
         This is effectively a shorthand for audio_emitter_bus(emitter, mux_bank_get(bank_name).bus).
		 If you have a MuxBank reference instead of a bank name, you should use the mux_bank_link_emitter() function instead
 * @param {Id.AudioEmitter} emitter The emitter to link to a bank's bus
 * @param {String} bank_name The name of the bank to link the supplied emitter to
 */
function mux_emitter_bank(emitter, bank_name) {
	mux_bank_link_emitter(mux_bank_get(bank_name), emitter);
}
