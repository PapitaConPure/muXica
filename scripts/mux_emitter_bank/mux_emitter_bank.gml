/**
 * @desc Links the supplied emitter to the bus from the bank specified by name.
         This is effectively a shorthand for audio_emitter_bus(emitter, mux_bank_get(bank_name).bus)
 * @param {Id.AudioEmitter} emitter The emitter to link to a bank's bus
 * @param {String} bank_name The name of the bank to link the supplied emitter to
 */
function mux_emitter_bank(emitter, bank_name) {
	audio_emitter_bus(emitter, mux_bank_get(bank_name).bus);
}
