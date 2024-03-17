/**
 * @desc Adds a new sound bank to the muXica audio system for latter usage
 * @param {Asset.GMAudioGroup} group
 */
function mux_bank_add(group) {
	array_push(MUX_GLOBAL.loaded_groups, group);
	
	var _name = __mux_string_to_struct_key(audio_group_name(group));
	MUX_HANDLER.mux_sounds[$ _name] = new MuxBank(_name, group);
}
