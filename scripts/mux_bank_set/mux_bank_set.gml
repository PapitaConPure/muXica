/**
 * @desc Adds a new sound bank to the muXica audio system for later usage.
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

/**
 * @desc Sets the gain of the specified MuxBank
 * @param {Id.AudioEmitter|String} bank The bank to set the gain of
 * @param {Real} gain The new gain of the bank
 * @param {Real} time The time it will take for the old gain to reach the new gain
 */
function mux_bank_set_gain(bank, gain, time = 0) {
	mux_bank_get(bank).set_gain(gain, time);
}

/**
 * @desc Links the supplied emitter to the bus from the specified muXica sound bank.
         This is effectively a shorthand for audio_emitter_bus(emitter, bank.bus).
		 If you have a bank name instead of a MuxBank reference, you can use the mux_emitter_bank() function instead
 * @param {Struct.MuxBank} bank The name of the bank to link the supplied emitter to
 * @param {Id.AudioEmitter} emitter The emitter to link to a bank's bus
 */
function mux_bank_link_emitter(bank, emitter) {
	audio_emitter_bus(emitter, bank.bus);
}