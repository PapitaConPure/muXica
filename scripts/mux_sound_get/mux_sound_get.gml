//feather ignore all

#region Checks
///@desc Checks if any sound of a certain sound asset or tag space is currently playing and not stopping.
///      If the index is the constant "all", every muXica sound will be checked against. This is the default
///@param {Asset.GMSound|Id.Sound|String|Constant.All} sound The umbrella of sounds to check for
function mux_sound_is_playing(sound = all) {
	MUX_CHECK_UNINITIALISED_EX_OR_FALSE
	
	if sound == all then return MUX_ALL.size > 0;
	
	var _i = 0; 
	var _found = false;
	var _bank;
	var _bank_size;
	
	if is_string(sound) {
		sound = __mux_string_to_struct_key(sound);
		MUX_EX_IF not variable_struct_exists(MUX_TAGS, sound) then __mux_ex($"Audio tag \"{sound}\" doesn't exist");
		
		var _tags_array = MUX_TAGS[$ sound];
		_bank = MUX_ALL;
		_bank_size = _bank.size;
		
		while(_i < _bank_size and not _found) {
			if _bank.has_sound(_i) and array_contains(_tags_array, _bank.get_sound(_i).index) then _found = true;
			
			_i++;
		}
		
		return _found;
	}
	
	if typeof(sound) == "ref" {
		MUX_CHECK_INVALID_EX;
		
		_bank = mux_bank_get_from_sound(sound);
		_bank_size = _bank.size;
	
		while(_i < _bank_size and not _found) {
			if _bank.has_sound(_i) and _bank.get_sound(_i).index == sound then _found = true;
			_i++;
		}
	
		return _found;
	}
	
	return __mux_sound_inst_is_playing(sound);
}

///@desc Checks if the specified sound instance is currently playing and not stopping
///      To check for all sound instances, an entire sound index or a tag, use mux_sound_any_is_playing
///@param {Id.Sound} inst The sound instance to check for
function __mux_sound_inst_is_playing(inst) {
	if not audio_exists(inst) then return false;
	if inst < 0 then __mux_ex(MUX_EX_INVALID);
	
	var _sound = mux_sound_get_from_inst(inst);
	if is_undefined(_sound) then return false;
	
	var _bank = mux_bank_get(_sound.emitter);
	var _bank_size = _bank.size;
	var _i = 0; 
	var _found = false;
	
	while(_i < _bank_size and not _found) {
		if _bank.has_sound(_i) and _bank.get_sound(_i).inst == inst then _found = true;
		_i++;
	}
	
	return _found;
}

///@desc Checks if any sound of a certain sound asset or tag space is currently paused
///@param {Asset.GMSound|Id.Sound|String|Constant.All} [sound] The umbrella of sounds to check for. By default, all will be checked
function mux_sound_any_is_paused(sound = all) {
	return array_any(mux_sound_get_array(sound), function(sound) { return not sound.playing; });
}
#endregion

#region Sound selections
///@desc Gets an array of sounds that fall under the specified umbrella of sounds
///@param {Asset.GMSound|Id.Sound|String|Constant.All} sound The sound umbrella to search for
///@returns {Array<Struct.MuxSound>}
function mux_sound_get_array(sound) {
	//Step 1: search by sound asset index
	if typeof(sound) == "ref" then return mux_sound_get_array_from_index(sound);
	
	//Step 2: search all
	if sound == all then return mux_sound_get_array_from_all();
	
	//Step 3: search by tag
	if is_string(sound) then return mux_sound_get_array_from_tag(sound);
	
	//Step 4: search for individual sound instance
	var _sound = mux_sound_get_from_inst(sound);
	
	//feather disable once GM1045
	if is_undefined(_sound) then return [];
	
	return [ _sound ];
}

///@returns {Array<Struct.MuxSound>}
function mux_sound_get_array_from_all() {
	var _all_bank = MUX_ALL;
	var _list_size = _all_bank.capacity;
	
	//feather disable once GM1045
	if _list_size == 0 then return [];
	
	var _arr = array_create(_all_bank.size);
	var _i = 0, _j = 0;
	
	repeat _list_size {
		if _all_bank.has_sound(_i)
			_arr[_j++] = _all_bank.get_sound(_i);
		
		_i++;
	}
	
	return _arr;
}

///@param {Asset.GMSound} index
///@returns {Array<Struct.MuxSound>}
function mux_sound_get_array_from_index(index) {
	var _bank = mux_bank_get_from_sound(index);
	var _list_size = _bank.capacity;
	
	//feather disable once GM1045
	if _list_size == 0 then return [];
	
	var _arr = array_create(_bank.size);
	var _i = 0, _j = 0;
	var _sound;
	
	repeat _list_size {
		if _bank.has_sound(_i) {
			_sound = _bank.get_sound(_i);
			if _sound.index == index then _arr[_j++] = _sound;
		}
		
		_i++;
	}
	
	array_resize(_arr, _j);
	
	return _arr;
}

///@param {String} index
///@returns {Array<Struct.MuxSound>}
function mux_sound_get_array_from_tag(tag) {
	tag = __mux_string_to_struct_key(tag);
	var _tags = MUX_TAGS[$ tag];
	var _all_bank = MUX_ALL;
	var _list_size = _all_bank.capacity;
	
	//feather disable once GM1045
	if _list_size == 0 then return [];
	
	var _i = 0, _j = 0;
	var _arr = array_create(_all_bank.size);
	var _snd;
	
	repeat _list_size {
		if _all_bank.has_sound(_i) {
			_snd = _all_bank.get_sound(_i);
		
			if array_contains(_tags, _snd.index)
				_arr[_j++] = _snd;
		}
			
		_i++;
	}
	
	array_resize(_arr, _j);
	
	return _arr;
}
#endregion

#region Data
///@desc Searches for a MuxSound associated to the specified sound instance id and returns it.
///      Returns undefined if no associated MuxSound instance is found
///@param {Id.Sound} inst The instance to search for
///@returns {Struct.MuxSound}
function mux_sound_get_from_inst(inst) {
	var _all_bank = MUX_ALL;
	var _list_size = _all_bank.capacity;
	
	//feather disable once GM1045
	if _list_size == 0 then return undefined;
	
	var _i = 0;
	var _snd;
	
	repeat _list_size {
		if _all_bank.has_sound(_i) {
			_snd = _all_bank.get_sound(_i);
			
			if _snd.inst == inst then return _snd;
		}
		
		_i++;
	}
	
	//If this point is reached, then there's no instance to be found
	//feather disable once GM1045
	return undefined;
}

///@desc Finds the designed bank index for the specified sound instance id, or -1 if the sound is not registered
///@param {Struct.MuxBank} bank
///@param {Id.Sound} inst
///@returns {Real}
function mux_sound_get_inst_bank_index(bank, inst) {
	var _list_size = bank.size;
	var _ret = -1;
	var _i = 0;
	
	while(_ret < 0 && _i < _list_size) {
		if bank.get_sound(_i).inst == inst then _ret = _i;
		else _i++;
	}
	
	return _ret;
}
///@desc Gets the oldest sound from the specified sound bank
///@param {Asset.GMAudioGroup|Constant.All} bank_id
///@returns {Struct.MuxSound}
///@deprecated
function mux_sound_get_oldest(bank_id = all) {
	var _bank_idx;
	if bank_id == all then _bank_idx = "all";
	else _bank_idx = audio_group_name(bank_id);
	var _group_bank = mux_bank_get(_bank_idx);
	return _group_bank.get_sound(0);
}

///@desc Gets the latest sound from the specified sound bank
///@param {Asset.GMAudioGroup|Constant.All} bank_id
///@returns {Struct.MuxSound}
///@deprecated
function mux_sound_get_latest(bank_id = all) {
	var _bank_idx;
	if bank_id == all then _bank_idx = "all";
	else _bank_idx = parse_bank_idx(bank_id);
	var _group_bank = mux_bank_get(_bank_idx);
	var _idx = _group_bank.size - 1;
	return _group_bank.get_sound(_idx);
}

///@desc Searches for the specified sound asset index. If no playing sound is found, returns undefined
///@param {Asset.GMSound} index
///@returns {Struct}
///@deprecated
function mux_sound_find(index) {
	var _bank_idx = audio_group_name(audio_sound_get_audio_group(index));
	var _group_bank = mux_bank_get(_bank_idx)
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

///@param {Asset.GMAudioGroup|Constant.All} bank_index
///@returns {String}
///@deprecated
function parse_bank_idx(bank_index) {
	if bank_index == all then return "all";
	if typeof(bank_index) == "ref" then return audio_group_name(bank_index);
	
	__mux_ex("Invalid bank index", $"Bank index \"{bank_index}\" is unknown or not a valid index");
}
#endregion
