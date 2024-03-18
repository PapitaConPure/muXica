//feather ignore all

/**
 * @desc Returns the MuxBank with the specified name
 * @param {Id.AudioEmitter|String} search The search term to get a bank
 * @returns {Struct.MuxBank}
 */
function mux_bank_get(search) {
	if is_string(search) then return MUX_BANKS[$ (__mux_string_to_struct_key(search))];
	return __mux_bank_get_from_bus(audio_emitter_get_bus(search));
}

/**
 * @desc Returns the bus associated with the specified MuxBank.
         Keep in mind that if you pass an audio emitter, then a linear search must be performed through all banks to find the one with a bus associated to this emitter
 * @param {Id.AudioEmitter|String} bank The bank to get the bus of
 * @returns {Struct.AudioBus}
 */
function mux_bank_get_bus(bank) {
	return mux_bank_get(bank).bus;
}

///@param {Struct.AudioBus} bus
///@returns {Struct.MuxBank}
function __mux_bank_get_from_bus(bus) {
	var _banks = MUX_BANKS;
	var _names = struct_get_names(_banks);
	var _count = array_length(_names);
	var _i = 0;
	var _name, _bank;
	
	repeat _count {
		_name = _names[_i++];
		_bank = _banks[$ _name];
		
		if _bank.bus == bus then return _bank;
	}
	
	//feather ignore GM1045
	return undefined;
}



///@param {Asset.GMSound|Id.Sound|Constant.All} sound
///@returns {Struct.MuxBank}
function mux_bank_get_from_sound(sound) {
	if sound == all then return MUX_ALL;
	
	var _index = audio_get_name(sound);
	var _sound_bank_index = MUX_GLOBAL.sound_bank_index;
	
	if not struct_exists(_sound_bank_index, _index) then return MUX_ALL;
	
	return _sound_bank_index[$ _index];
}
