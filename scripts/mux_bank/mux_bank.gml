/**
 * @desc Represents a bank/group of MuxSounds that are all of similar nature and processed in the same way.
 *       Internally, it's an array-based dynamic list that can grow twice its capacity when needed, and is processed in a wrapped, fragmented fashion.
 *       It's capacity can be reduced to fit only the current sounds it contains with MuxBank.shrink_capacity()
 * @param {String} name The name of the bank
 */
function MuxBank(name) constructor {
	self.name = name;
	self.size = 0;
	self.capacity = 2;
	self.sounds = array_create(self.capacity, undefined);
	self.head = 0;
	
	///@desc Adds a sound to this bank at the current head position
	///@param {Struct.MuxSound} sound The sound to add
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
		
		//Resize this bank if there's no room for the new sound
		if not _found_available {
			_new_idx = self.capacity;
			self.capacity *= 2;
			array_resize(self.sounds, self.capacity);
			
			for(var _i = _new_idx + 1; _i < self.capacity; _i++) {
				self.sounds[_i] = undefined;
			}
		}
		
		self.head = _new_idx;
		sound.add_index(self.name, _new_idx);
		self.sounds[_new_idx] = sound;
		self.size++;
	}
	
	///@desc Removes the specified sound from this bank
	///@param {Struct.MuxSound} sound The sound to remove
	static remove_sound = function(sound) {
		var _idx = self.get_index_of(sound);
		
		if _idx < 0 then return;
		
		sound.remove_index(self.name);
		self.sounds[_idx] = undefined;
		self.size--;
	}
	
	///@desc Removes a sound from this bank at the specified position
	///@param {Real} idx The position from which a sound will be removed
	static remove_sound_at = function(idx) {
		self.sounds[idx].remove_index(self.name);
		self.sounds[idx] = undefined;
		self.size--;
	}
	
	/**
	 * @desc Replaces the specified sound in this bank with the supplied new sound
	 * @param {Struct.MuxSound} old_sound The sound that will be replaced by the new one
	 * @param {Struct.MuxSound} new_sound The sound that will replace the old one
	 */
	static replace_sound = function(old_sound, new_sound) {
		old_sound.remove_index(self.name);
		
		var _idx = self.get_index_of(old_sound);
		new_sound.add_index(self.name, _idx);
		self.sounds[_idx] = new_sound;
	}
	
	/**
	 * @desc Replaces the sound at the bank's specified position with the supplied new sound
	 * @param {Real} idx The position of the sound to replace
	 * @param {Struct.MuxSound} new_sound The new sound that will occupy the specified position instead
	 */
	static replace_sound_at = function(idx, new_sound) {
		self.sounds[idx].remove_index(self.name);
		
		new_sound.add_index(self.name, idx);
		self.sounds[idx] = new_sound;
	}
	
	/**
	 * @desc Checks whether this bank contains a sound in the specified index (true) or not (false).
	 *       This function will never throw an exception, and will return false if the supplied index is out of range
	 * @param {Real} idx The sound index to check for within the bank
	 */
	static has_sound = function(idx) {
		if idx < 0 or idx > self.capacity then return false;
		
		return not is_undefined(self.sounds[idx]);
	}
	
	///@desc Returns true if the bank doesn't contain any sounds and false otherwise
	///@returns {Bool}
	static is_empty = function() {
		return self.size == 0;
	}
	
	/**
	 * @desc Gets a sound from this bank
	 * @param {Real} idx
	 * @returns {Struct.MuxSound}
	 */
	static get_sound = function(idx) {
		if idx < 0 or idx > self.capacity then __mux_ex(MUX_EX_BANK_INDEX_OOR);
		
		var _sound = self.sounds[idx];
		
		if is_undefined(_sound)
			__mux_ex("Sound bank index was invalid", $"Tried to access an invalid index {idx} for sound bank \"{self.name}\"");
		
		//feather disable once GM1045
		return _sound;
	}
	
	/**
	 * @desc Gets the index of the specified MuxSound instance within the bank
	 * @param {Struct.MuxSound} sound
	 * @returns {Real}
	 */
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
	
	/**
	 * @desc Finds the index of the described sound within the bank and returns it
	 * @param {Asset.GMSound|Id.Sound} sound
	 * @returns {Struct.MuxSound}
	 */
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
	
	/**
	 * @desc Finds the index of the described sound within the bank and returns it
	 * @param {Asset.GMSound|Id.Sound} sound
	 * @returns {Real}
	 */
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
	
	///@desc Defragments and updates all the sounds' positions within the bank and reduces the capacity to the current amount of sounds (minimum capacity: 4)
	static shrink_capacity = function() {
		var _sounds = ds_list_create();
		
		var _i = 0;
		var _snd;
		repeat self.capacity {
			_snd = self.sounds[_i++];
			if not is_undefined(_snd) then ds_list_add(_sounds, _snd);
		}
		
		var _new_capacity = ds_list_size(_sounds);
		var _actual_capacity = max(4, _new_capacity);
		self.sounds = array_create(_actual_capacity, undefined);
		self.size = _new_capacity;
		self.capacity = _actual_capacity;
		
		_i = 0;
		repeat _new_capacity {
			_snd = _sounds[| _i];
			_snd.add_index(self.name, _i);
			self.sounds[_i++] = _snd;
		}
		
		ds_list_destroy(_sounds);
	}
	
	///@desc Removes and unlinks all associated sounds from this bank
	static flush = function() {
		var _i = 0;
		var _snd;
		repeat self.capacity {
			_snd = self.sounds[_i];
			if is_undefined(_snd) then continue;
			_snd.remove_index(self.name);
			self.sounds[_i++] = undefined;
		}
	}
}