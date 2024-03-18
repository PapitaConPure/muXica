/**
 * @desc Adds a new sound bank to the muXica audio system for latter usage.
 *       You can also pass an array of sound asset indexes to link to the new bank.
 *       This is useful for when you want a specific sound to have a default emitter other than the master muXica emitter, and therefore a default bus which is the new bank's bus
 * @param {String} bank_name The name of the new bank
 * @param {Array<Asset.GMSound>} sound Sound asset index to link to the new bank
 */
function mux_bank_create(bank_name, linked_sounds = []) {
	var _bank = new MuxBank(bank_name, audio_bus_create());
	MUX_HANDLER.mux_sounds[$ bank_name] = _bank;
	
	var _length = array_length(linked_sounds);
	var _i = 0;
	var _sound, _index;
	
	repeat _length {
		_sound = linked_sounds[_i++];
		_index = audio_get_name(_sound);
		MUX_GLOBAL.sound_bank_index[$ _index] = _bank;
	}
}

/**
 * @desc Links sound asset indexes to a muXica sound bank.
 *       This is useful for when you want a specific sound to have a default emitter other than the master muXica emitter, and therefore a default bus which is the bank's bus
 * @param {String} bank_name The name of the bank that the sound asset index will be linked to
 * @param {Array<Asset.GMSound>} sound The sound asset index to link to the bank
 */
function mux_bank_link(bank_name, sounds) {
	var _bank = mux_bank_get(bank_name);
	var _length = array_length(sounds);
	var _i = 0;
	var _sound, _index;
	
	repeat _length {
		_sound = sounds[_i++];
		_index = audio_get_name(_sound);
		MUX_GLOBAL.sound_bank_index[$ _index] = _bank;
	}
}
