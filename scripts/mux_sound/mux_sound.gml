/**
 * @desc Represends an audio block
 * @param {Asset.GMSound} index Sound asset index
 * @param {Id.Sound} inst Sound instance id
 * @param {Bool} keep_alive=false Whether to keep the sound alive after it reaches 0 gain (true) or not (false)
 * @constructor
 */
function MuxSound(index, inst) constructor {
	self.index = index;
	self.inst = inst;
	
	self.ppos = 0;
	self.pos = 0;
	self.playing = true;
	self.updated = false;
	self.pitch = audio_sound_get_pitch(inst);
	
	self.name = audio_get_name(index);
	self.group = audio_sound_get_audio_group(index);
	self.length = audio_sound_length(index);
	
	self.group_index = {};
	
	self.__reset_ppos = -1;
	self.__next_pos = -1;
	
	//Automatically attach to handler's corresponding MuxArranger if it exists (for cue event handling magic)
	var _key = audio_get_name(index);
	if struct_exists(MUX_ARRANGERS, _key)
		ds_list_add(MUX_ARRANGERS[$ _key].instances, self);
	
	update = function() {
		self.updated = false;
		if not self.playing then return;
		
		//Actually, fuck GameMaker's audio support. I'll sync it my-fucking-self
		var _new_pos = self.pos + delta_time * 0.000001 * self.pitch; //audio_sound_get_track_position(self.inst);
		
		if self.__reset_ppos < 0 {
			self.ppos = self.pos;
		} else {
			self.ppos = self.__reset_ppos;
			self.__reset_ppos = -1;
		}
		
		self.pos = _new_pos;
		self.updated = true;
	}
	
	post_update = function() {
		if self.__next_pos < 0 then return;
		self.pos = self.__next_pos;
		self.__next_pos = -1;
	}
	
	///@param {Real} position The new track position for this sound instance, in seconds
	///@param {Real} [reset_ppos] Whether to reset the previous track position to a certain time (in seconds, 0 or higher) or leave it as it was (-1)
	set_track_position = function(position, reset_ppos = -1) {
		audio_sound_set_track_position(self.inst, position)
		
		audio_sound_set_track_position(self.inst, position);
		self.__reset_ppos = reset_ppos;
		self.__next_pos = position;
	}
	
	///@param {Real} pitch Pitch of the sound, where 1 is normal pitch
	set_pitch = function(pitch) {
		self.pitch = pitch;
	}
	
	pause = function() {
		audio_pause_sound(self.inst);
		self.playing = false;
	}
	
	resume = function() {
		audio_resume_sound(self.inst);
		self.playing = true;
	}
	
	///@param {Bool} keep_alive Whether the sound instance should remain alive (true) or be entirely destroyed (false, default)
	stop = function(keep_alive = false) {
		if keep_alive {
			audio_pause_sound(self.inst);
			audio_sound_set_track_position(self.inst, 0);
		} else
			audio_stop_sound(self.inst);
		
		self.__reset_ppos = 0;
		self.__next_pos = 0;
		self.playing = false;
	}
	
	///@param {String} group_name The name of the group this sound will be linked to
	///@param {Real} group_index The internal index this sound will occupy within the group
	link = function(group_name, group_index) {
		self.group_index[group_name] = group_index;
	}
}
