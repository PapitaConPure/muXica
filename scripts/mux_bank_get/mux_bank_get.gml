/**
 * @desc Returns the MuxBank with the specified name
 * @param {Asset.GMAudioGroup|String} bank The bank to get
 * @returns {Struct.MuxBank}
 */
function mux_bank_get(bank) {
	var _bank_name;
	if is_string(bank) then _bank_name = bank;
	else _bank_name = audio_group_name(bank);
	_bank_name = __mux_string_to_struct_key(_bank_name);
	
	return MUX_HANDLER.mux_sounds[$ _bank_name];
}

/**
 * @desc Returns the gain of the specified MuxBank
 * @param {Asset.GMAudioGroup|String} bank The name of the bank to get the gain of
 * @returns {Real}
 */
function mux_bank_get_gain(bank) {
	return mux_bank_get(bank).gain;
}