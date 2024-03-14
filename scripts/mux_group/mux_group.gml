/**
 * @desc Represents a group of MuxSounds that are all of similar nature and processed in the same way
 * @param {String} name The name of the group
 */
function MuxGroup(name) constructor {
	self.name = name;
	self.size = 0;
	self.capacity = 4;
	self.sounds = array_create(self.capacity, undefined);
	self.head = 0;
	
	///@desc Adds a sound to this group
	///@param {Struct.MuxSound} sound
	static add_sound = function(sound) {
		var _new_idx = self.head;
		if _new_idx >= self.capacity then _new_idx = 0;
		
		//Find nearest index available in a round/wrapped fashion
		var _starting_point = _new_idx;
		var _found_available = false;
		do {
			if is_undefined(self.sounds[_new_idx]) {
				_found_available = true;
			} else {
				if(_new_idx < (self.capacity - 1)) then _new_idx++;
				else _new_idx = 0;
			}
		} until(_found_available or _new_idx == _starting_point);
		
		//Resize this group if there's no room for the new sound
		if not _found_available {
			_new_idx = self.capacity;
			self.capacity *= 2;
			array_resize(self.sounds, self.capacity);
			
			for(var _i = _new_idx + 1; _i < self.capacity; _i++) {
				self.sounds[_i] = undefined;
			}
		}
		
		self.head = _new_idx;
		sound.link(self.name, _new_idx);
		self.sounds[_new_idx] = sound;
		self.size++;
	}
	
	///@desc Removes the specified sound from this group
	///@param {Struct.MuxSound} sound
	static remove_sound = function(sound) {
		var _idx = self.get_index_of(sound);
		
		if not _found then return;
		
		sound.unlink(self.name);
		self.sounds[_idx] = undefined;
		self.size--;
	}
	
	///@desc Removes a sound from this group at the specified position
	///@param {Real} idx The position from which a sound will be removed
	static remove_sound_at = function(idx) {
		self.sounds[idx].unlink(self.name);
		self.sounds[idx] = undefined;
		self.size--;
	}
	
	static replace_sound = function(old_sound, new_sound) {
		old_sound.unlink(self.name);
		
		var _idx = self.get_index_of(old_sound);
		new_sound.link(self.name, _idx);
		self.sounds[_idx] = new_sound;
	}
	
	static replace_sound_at = function(idx, new_sound) {
		self.sounds[idx].unlink(self.name);
		
		new_sound.link(self.name, idx);
		self.sounds[idx] = new_sound;
	}
	
	///@desc Gets a sound from this group
	///@param {Real} idx
	///@returns {Struct.MuxSound}
	static get_sound = function(idx) {
		if idx < 0 or idx > self.capacity
			__mux_ex("Sound group index was out of range", $"Tried to access an index out of the bounds {idx} for sound group \"{self.name}\"");
		
		var _sound = self.sounds[idx];
		
		if is_undefined(_sound)
			__mux_ex("Sound group index was invalid", $"Tried to access an invalid index {idx} for sound group \"{self.name}\"");
		
		//feather disable once GM1045
		return _sound;
	}
	
	///@desc Gets the index of the specified MuxSound instance within the group
	///@param {Struct.MuxSound} sound
	///@returns {Real}
	static get_index_of = function(sound) {
		var _idx = -1;
		var _found = false;
		var _snd;
		
		while not _found and _idx < self.capacity {
			_snd = self.sounds[++_idx];
			if not is_undefined(_snd) and _snd == sound then _found = true;
		}
		
		return _found ? _idx : -1;
	}
	
	///@desc Finds the index of the described sound within the group and returns it
	///@param {Asset.GMSound|Id.Sound} sound
	///@returns {Struct.MuxSound}
	static find_sound = function(sound) {
		var _idx = -1;
		var _found = undefined;
		var _snd;
		
		while _idx < self.capacity and is_undefined(_found) {
			_snd = self.sounds[++_idx];
			if is_undefined(_snd) then continue;
			if _snd.index == sound or _snd.inst == sound then _found = _snd;
		}
		
		return _found;
	}
	
	///@desc Finds the index of the described sound within the group and returns it
	///@param {Asset.GMSound|Id.Sound} sound
	///@returns {Real}
	static find_index_of = function(sound) {
		var _idx = -1;
		var _found = false;
		var _snd;
		
		while not _found and _idx < self.capacity {
			_snd = self.sounds[++_idx];
			if is_undefined(_snd) then continue;
			if _snd.index == sound or _snd.inst == sound then _found = true;
		}
		
		return _found ? _idx : -1;
	}
	
	///@desc Defragments and updates all the sounds' positions within the group and reduces the capacity to the current amount of sounds
	static shrink_capacity = function() {
		var _sounds = ds_list_create();
		
		var _i = 0;
		var _snd;
		repeat self.capacity {
			_snd = self.sounds[_i++];
			if not is_undefined(_snd) then ds_list_add(_sounds, _snd);
		}
		
		var _new_capacity = ds_list_size(_sounds);
		self.sounds = array_create(_new_capacity, undefined);
		
		_i = 0;
		repeat _new_capacity {
			_snd = _sounds.get_sound(_i);
			_snd.link(self.name, _i);
			self.sounds[_i++] = _snd;
		}
		
		ds_list_destroy(_sounds);
	}
	
	///@desc Removes and unlinks all associated sounds from this group
	static flush = function() {
		var _i = 0;
		var _snd;
		repeat self.capacity {
			self.sounds[_i].unlink(self.name);
			self.sounds[_i] = undefined;
			_i++;
		}
	}
	
	static has_sound = function(idx) {
		return not is_undefined(self.sounds[idx]);
	}
	
	static is_empty = function() {
		return self.size == 0;
	}
}