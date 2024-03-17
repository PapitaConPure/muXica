/**
 * @desc Sets the gain of the specified MuxBank
 * @param {Asset.GMAudioGroup|String} bank_name The bank to set the gain of
 * @param {Real} gain The new gain of the bank
 * @param {Real} time The time it will take for the old gain to reach the new gain
 */
function mux_bank_set_gain(bank, gain, time = 0) {
	mux_bank_get(bank).set_gain(gain, time);
}
