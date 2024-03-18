/**
 * @desc Creates a new audio emitter, links it to the specified muXica sound bank, and returns it.
 *       You must still call the audio_emitter_free() function when you're done with the emitter
 * @param {Id.AudioEmitter|String} bank
 */
function mux_emitter_create(bank) {
	var _emitter =  audio_emitter_create();
	var _bank = mux_bank_get(bank);
	mux_emitter_bank(_emitter, bank);
	return _emitter;
}
