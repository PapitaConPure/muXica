/**
 * @desc Adds a new sound bank to the muXica audio system for latter usage
 * @param {String} bank_name The name of the new bank
 */
function mux_bank_add(bank_name) {
	MUX_HANDLER.mux_sounds[$ bank_name] = new MuxBank(bank_name, audio_bus_create());
}

/**
 * @desc Links a sound asset index to a muXica sound bank.
 *       This is useful for when you want a specific sound to have a default emitter other than the master muXica emitter, and therefore a default bus which is the bank's bus
 * @param {String} bank_name The name of the bank that the sound asset index will be linked to
 * @param {Asset.GMSound} sound The sound asset index to link to the bank
 */
function mux_bank_link(bank_name, sound) {
	var _index = audio_get_name(sound);
	MUX_GLOBAL.sound_bank_index[$ _index] = mux_bank_get(bank_name);
}