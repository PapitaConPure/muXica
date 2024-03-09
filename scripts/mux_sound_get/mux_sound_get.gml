/// @param {Asset.GMAudioGroup|Constant.All} group_id
/// @returns {Struct}
function mux_sound_get_oldest(group_id) {
	var _group_idx;
	if group_id == all then _group_idx = "all";
	else _group_idx = audio_group_name(group_id);
	var _group_bank = MUX_GROUPS[$ _group_idx];
	return _group_bank[| 0];
}

///@desc Description
///@param {Asset.GMAudioGroup|Constant.All} group_id
///@returns {Struct}
function mux_sound_get_latest(group_id = all) {
	var _group_idx;
	if group_id == all then _group_idx = "all";
	else _group_idx = parse_group_idx(group_id);
	var _group_bank = MUX_GROUPS[$ _group_idx];
	var _idx = ds_list_size(_group_bank) - 1;
	return _group_bank[| _idx];
}

/// @desc If no playing sound is found, returns undefined
/// @param {Asset.GMSound} index
/// @returns {Struct}
function mux_sound_find(index) {
	var _group_idx = audio_group_name(audio_sound_get_audio_group(index));
	var _group_bank = MUX_GROUPS[$ _group_idx]
	var _list_size = ds_list_size(_group_bank);
	var _i = 0; 
	var _found = false;
	var _ret = undefined;
	
	while(_i < _list_size and not _found) {
		if _group_bank[| _i].inst == index {
			_ret = _group_bank[| _i];
			_found = true;
		}
		
		_i++;
	}
	
	return _ret;
}

/// @desc Finds the designed bank index for the specified sound instance id, or -1 if the sound is not registered
///@param {Id.DsList} group_id
///@param {Id.Sound} inst
///@returns {Real}
function mux_sound_get_inst_bank_index(group, inst) {
	var _list_size = ds_list_size(group);
	var _ret = -1;
	var _i = 0;
	
	while(_ret < 0 && _i < _list_size) {
		if group[| _i].inst == inst then _ret = _i;
		else _i++;
	}
	
	return _ret;
}

///@desc Checks if any sound of a certain sound asset or tag space is currently playing and not stopping.
///      If the index is the constant "all", every muXica sound will be checked against. This is the default
///@param {Constant.All|Asset.GMSound|String} index The umbrella of sounds to check for
function mux_sound_any_is_playing(index = all) {
	MUX_CHECK_UNINITIALISED_EX_OR_FALSE
	
	if index == all then return ds_list_size(MUX_ALL) > 0;
	
	var _i = 0; 
	var _found = false;
	var _group_bank;
	var _list_size;
	
	if is_string(index) {
		MUX_EX_IF not variable_struct_exists(MUX_TAGS, index) then __mux_ex($"Audio tag \"{index}\" doesn't exist");
		
		var _tags_array = MUX_TAGS[$ index];
		_group_bank = MUX_ALL;
		_list_size = ds_list_size(_group_bank);
		
		while(_i < _list_size and not _found) {
			if array_get_index(_tags_array, _group_bank[| _i].index) >= 0 then _found = true;
			
			_i++;
		}
		
		return _found;
	}
	
	MUX_CHECK_INVALID_EX
	
	var _group_idx = audio_group_name(audio_sound_get_audio_group(index));
	_group_bank = MUX_GROUPS[$ _group_idx];
	_list_size = ds_list_size(_group_bank);
	
	while(_i < _list_size and not _found) {
		if _group_bank[| _i].index == index then _found = true;
		_i++;
	}
	
	return _found;
}

///@desc Checks if the specified sound instance is currently playing and not stopping
///      To check for all sound instances, an entire sound index or a tag, use mux_sound_any_is_playing
///@param {Id.Sound} inst The sound instance to check for
function mux_sound_is_playing(inst) {
	MUX_CHECK_INVALID_EX
	
	var _group_idx =  audio_group_name(audio_sound_get_audio_group(inst));
	var _group_bank = MUX_GROUPS[$ _group_idx];
	var _list_size = ds_list_size(_group_bank);
	var _i = 0; 
	var _found = false;
	
	while(_i < _list_size and not _found) {
		if _group_bank[| _i].inst == inst then _found = true;
		_i++;
	}
	
	return _found;
}

/// @param {Asset.GMAudioGroup|Constant.All} group_id
///@returns {String}
function parse_group_idx(group_id) {
	switch group_id {
	case all: return "all";
	case BGM: return "BGM";
	case SFX: return "SFX";
	default:  __mux_ex("ID de grupo de audio inválida", $"La ID \"{group_id}\" es desconocida o no es una ID válida");
	}
}