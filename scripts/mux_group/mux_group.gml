/**
 * @desc Represents a group of MuxSounds that are all of similar nature and processed in the same way
 * @param {String} name The name of the group
 */
function MuxGroup(name) constructor {
	self.name = name;
	self.capacity = 4;
	self.sounds = array_create(self.capacity, undefined);
	
	///@desc Adds a sound to this group
	///@param {Struct.MuxSound} sound
	add_sound = function(sound) {
		static _new_idx = 0;
		
		//Find nearest index available in a round/wrapped fashion
		var _starting_point = _new_idx;
		var _found_available = false;
		do {
			_found_available = is_undefined(self.sounds[_new_idx]);
			if _new_idx < self.capacity then _new_idx++;
			else _new_idx = 0;
		} until(_found_available or _new_idx == _starting_point);
		
		//Resize this group if there's no room for the new sound
		if not _found_available {
			_new_idx = self.capacity;
			self.capacity *= 2;
			array_resize(self.sounds, self.capacity);
		}
		
		self.sounds[_new_idx] = sound;
	}
	
	///@desc Removes a sound from this group at the specified position
	///@param {Real} idx The position from which a sound will be removed
	remove_sound_at = function(idx) {
		self.sounds[idx] = undefined;
	}
	
	///@desc Gets a sound from this group
	///@param {Real} idx
	///@returns {Struct.MuxSound}
	get_sound = function(idx) {
		if idx < 0 or idx > self.capacity
			__mux_ex("Sound group index was out of range", $"Tried to access an index out of the bounds {idx} for sound group \"{self.name}\"");
		
		var _sound = self.sounds[idx];
		
		if is_undefined(_sound)
			__mux_ex("Sound group index was invalid", $"Tried to access an invalid index {idx} for sound group \"{self.name}\"");
		
		//feather disable once GM1045
		return _sound;
	}
	
	///@desc Defragments and updates all the sounds' positions within the group and reduces the capacity to the current amount of sounds
	shrink_capacity = function() {
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
			_snd = self.sounds[| _i];
			_snd.link(self.name, _i);
			self.sounds[_i++] = _snd;
		}
		
		ds_list_destroy(_sounds);
	}
}