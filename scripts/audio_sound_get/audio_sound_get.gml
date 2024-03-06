/// @param {Asset.GMAudioGroup|Constant.All} group_id
/// @returns {Struct}
function audio_sound_get_oldest(group_id) {
	var _group_idx;
	if group_id == all then _group_idx = "all";
	else _group_idx = audio_group_name(group_id);
	var _group_bank = MUX_GROUPS[$ _group_idx];
	return _group_bank[| 0];
}

///@desc Description
///@param {Asset.GMAudioGroup|Constant.All} group_id
///@returns {Struct}
function audio_sound_get_latest(group_id = all) {
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
function audio_sound_find(index) {
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
function audio_sound_get_inst_bank_index(group, inst) {
	var _list_size = ds_list_size(group);
	var _ret = -1;
	var _i = 0;
	
	while(_ret < 0 && _i < _list_size) {
		if group[| _i].inst == inst then _ret = _i;
		else _i++;
	}
	
	return _ret;
}

///@desc Checks if any sound under the audio index is currently playing and not stopping
///@param {Constant.All|Asset.GMSound|String} index
///@returns {Bool}
function audio_any_is_playing(index = all) {
	MUX_CHECK_UNINITIALISED_EX_OR_FALSE
	
	if index == all then return ds_list_size(MUX_ALL) > 0;
	
	var _i = 0; 
	var _found = false;
	var _group_bank;
	var _list_size;
	
	if is_string(index) {
		if MUX_EX_ENABLE and not variable_struct_exists(global.audio_tags, index) then __audio_error($"Audio tag \"{index}\" doesn't exist");
		
		var _tags_array = global.audio_tags[$ index];
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

///@desc Checks if the audio is currently playing and not stopping
///@param {Id.Sound} index
function audio_sound_is_playing(index) {
	MUX_CHECK_INVALID_EX
	
	var _group_idx =  audio_group_name(audio_sound_get_audio_group(index));
	var _group_bank = MUX_GROUPS[$ _group_idx];
	var _list_size = ds_list_size(_group_bank);
	var _i = 0; 
	var _found = false;
	
	while(_i < _list_size and not _found) {
		if _group_bank[| _i].inst == index then _found = true;
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
	default:  throw  "ID de grupo de audio desconocida";
	}
}