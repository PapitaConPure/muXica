/// @param {Asset.GMAudioGroup|Constant.All} group_id
/// @returns {Struct}
function mux_sound_get_oldest(group_id) {
	var _group_idx;
	if group_id == all then _group_idx = "all";
	else _group_idx = audio_group_name(group_id);
	var _group_bank = mux_handler_get_group(_group_idx);
	return _group_bank.get_sound(0);
}

///@desc Description
///@param {Asset.GMAudioGroup|Constant.All} group_id
///@returns {Struct}
function mux_sound_get_latest(group_id = all) {
	var _group_idx;
	if group_id == all then _group_idx = "all";
	else _group_idx = parse_group_idx(group_id);
	var _group_bank = mux_handler_get_group(_group_idx);
	var _idx = _group_bank.size - 1;
	return _group_bank.get_sound(_idx);
}

///@param {Asset.GMSound|Id.Sound|Constant.All} sound The sound to search for
///@returns {Array<Struct.MuxSound>}
function mux_sound_get_array(sound) {
	if typeof(sound) == "ref" then return mux_sound_get_array_from_index(sound);
	
	if sound == all then return mux_sound_get_array_from_all();
	
	if is_string(sound) then return mux_sound_get_array_from_tag(sound);
	
	return [ mux_sound_get_from_inst(sound) ];
}

///@returns {Array<Struct.MuxSound>}
function mux_sound_get_array_from_all() {
	var _all_group = MUX_ALL;
	var _list_size = _all_group.size;
	
	//feather disable once GM1045
	if _list_size == 0 then return [];
	
	var _arr = array_create(_list_size);
	var _i = 0;
	
	repeat _list_size {
		_arr[_i] = _all_group.get_sound(_i);
		_i++;
	}
	
	//feather disable once GM1045
	return _arr;
}

///@param {Asset.GMSound} index
///@returns {Array<Struct.MuxSound>}
function mux_sound_get_array_from_index(index) {
	var _group_idx = audio_group_name(audio_sound_get_audio_group(index));
	var _group_bank = mux_handler_get_group(_group_idx)
	var _list_size = _group_bank.size;
	
	//feather disable once GM1045
	if _list_size == 0 then return [];
	
	var _i = 0;
	var _arr = array_create(_list_size);
	
	repeat _list_size {
		_arr[_i] = _group_bank.get_sound(_i);
		_i++;
	}
	
	//feather disable once GM1045
	return _arr;
}

///@param {String} index
///@returns {Array<Struct.MuxSound>}
function mux_sound_get_array_from_tag(tag) {
	var _tags = MUX_TAGS;
	var _all_group = MUX_ALL;
	var _list_size = _all_group.size;
	
	//feather disable once GM1045
	if _list_size == 0 then return [];
	
	var _i = 0;
	var _arr = array_create(_list_size);
	var _snd;
	
	repeat _list_size {
		_snd = _group_bank.get_sound(_i);
		if _snd
		_arr[_i] = _snd;
		_i++;
	}
	
	//feather disable once GM1045
	return _arr;
}

///@param {Id.Sound} inst
///@returns {Struct.MuxSound}
function mux_sound_get_from_inst(inst) {
	
}

/// @desc If no playing sound is found, returns undefined
/// @param {Asset.GMSound} index
/// @returns {Struct}
function mux_sound_find(index) {
	var _group_idx = audio_group_name(audio_sound_get_audio_group(index));
	var _group_bank = mux_handler_get_group(_group_idx)
	var _list_size = _group_bank.size;
	var _i = 0; 
	var _found = false;
	var _ret = undefined;
	
	while(_i < _list_size and not _found) {
		if _group_bank.get_sound(_i).inst == index {
			_ret = _group_bank.get_sound(_i);
			_found = true;
		}
		
		_i++;
	}
	
	return _ret;
}

/// @desc Finds the designed group index for the specified sound instance id, or -1 if the sound is not registered
///@param {Struct.MuxGroup} group
///@param {Id.Sound} inst
///@returns {Real}
function mux_sound_get_inst_group_index(group, inst) {
	var _list_size = group.size;
	var _ret = -1;
	var _i = 0;
	
	while(_ret < 0 && _i < _list_size) {
		if group.get_sound(_i).inst == inst then _ret = _i;
		else _i++;
	}
	
	return _ret;
}

///@desc Checks if any sound of a certain sound asset or tag space is currently playing and not stopping.
///      If the index is the constant "all", every muXica sound will be checked against. This is the default
///@param {Constant.All|Asset.GMSound|String} index The umbrella of sounds to check for
function mux_sound_any_is_playing(index = all) {
	MUX_CHECK_UNINITIALISED_EX_OR_FALSE
	
	if index == all then return MUX_ALL.size > 0;
	
	var _i = 0; 
	var _found = false;
	var _group_bank;
	var _list_size;
	
	if is_string(index) {
		MUX_EX_IF not variable_struct_exists(MUX_TAGS, index) then __mux_ex($"Audio tag \"{index}\" doesn't exist");
		
		var _tags_array = MUX_TAGS[$ index];
		_group_bank = MUX_ALL;
		_list_size = _group_bank.size;
		
		while(_i < _list_size and not _found) {
			if array_get_index(_tags_array, _group_bank.get_sound(_i).index) >= 0 then _found = true;
			
			_i++;
		}
		
		return _found;
	}
	
	MUX_CHECK_INVALID_EX
	
	var _group_idx = audio_group_name(audio_sound_get_audio_group(index));
	_group_bank = mux_handler_get_group(_group_idx);
	_list_size = _group_bank.size;
	
	while(_i < _list_size and not _found) {
		if _group_bank.get_sound(_i).index == index then _found = true;
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
	var _group_bank = mux_handler_get_group(_group_idx);
	var _list_size = _group_bank.size;
	var _i = 0; 
	var _found = false;
	
	while(_i < _list_size and not _found) {
		if _group_bank.get_sound(_i).inst == inst then _found = true;
		_i++;
	}
	
	return _found;
}

///@desc Checks if any sound of a certain sound asset or tag space is currently paused
///@param {Asset.GMSound|Id.Sound|Constant.All} sound The umbrella of sounds to check for. By default, all will be checked
function mux_sound_any_is_paused(sound = all) {
	return array_any(mux_sound_get_array(sound), function(sound) { return not sound.playing; });
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