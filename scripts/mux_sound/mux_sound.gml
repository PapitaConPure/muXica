/**
 * @desc Represents an audio block
 * @param {Asset.GMSound} index Sound asset index
 * @param {Id.Sound} inst Sound instance id
 * @param {Bool} keep_alive=false Whether to keep the sound alive after it reaches 0 gain (true) or not (false)
 * @constructor
 */
function MuxSound(index, inst) constructor {
	self.index = index;
	self.inst = inst;
	
	self.pos = audio_sound_get_track_position(inst);
	self.ppos = self.pos;
	self.playing = true;
	self.stopped = false;
	self.updated = false;
	self.pitch = audio_sound_get_pitch(inst);
	
	self.name = audio_get_name(index);
	self.group = audio_sound_get_audio_group(index);
	self.length = audio_sound_length(index);
	
	self.group_index = {};
	
	self.__reset_ppos = -1;
	self.__next_pos = -1;
	
	//Automatically attach to handler's corresponding MuxArranger if it exists (for cue event handling magic)
	var _arrangers = MUX_ARRANGERS;
	var _key = ds_grid_value_x(_arrangers, 0, MUX_ARR_F.NAME, ds_grid_width(_arrangers) - 1, MUX_ARR_F.NAME, self.name);
	if _key >= 0 {
		ds_list_add(_arrangers[# _key, MUX_ARR_F.STRUCT].instances, self);
	}
	
	static update = function() {
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
	
	static post_update = function() {
		if self.__next_pos < 0 then return;
		self.pos = self.__next_pos;
		self.__next_pos = -1;
	}
	
	///@param {Real} position The new track position for this sound instance, in seconds
	///@param {Real} [reset_ppos] Whether to reset the previous track position to a certain time (in seconds, 0 or higher) or leave it as it was (-1)
	static set_track_position = function(position, reset_ppos = -1) {
		audio_sound_set_track_position(self.inst, position);
		self.__reset_ppos = reset_ppos;
		self.__next_pos = position;
	}
	
	///@param {Real} pitch Pitch of the sound, where 1 is normal pitch
	static set_pitch = function(pitch) {
		self.pitch = pitch;
	}
	
	static pause = function() {
		audio_pause_sound(self.inst);
		self.playing = false;
	}
	
	static resume = function() {
		audio_resume_sound(self.inst);
		self.playing = true;
	}
	
	///@param {Bool} keep_alive Whether the sound instance should remain alive (true) or be entirely destroyed (false, default)
	static stop = function(keep_alive = false) {
		if keep_alive {
			audio_pause_sound(self.inst);
			audio_sound_set_track_position(self.inst, 0);
		} else
			audio_stop_sound(self.inst);
		
		self.__reset_ppos = 0;
		self.__next_pos = 0;
		self.playing = false;
		self.free();
	}
	
	///@param {String} group_name The name of the group this sound will be linked to
	///@param {Real} group_index The internal index this sound will occupy within the group
	static link = function(group_name, group_index) {
		self.group_index[$ group_name] = group_index;
	}
	
	///@param {String} group_name The name of the group this sound will be unlinked from
	static unlink = function(group_name) {
		self.group_index[$ group_name] = undefined;
	}
	
	///@param {String} group_name  The name of the group to get the sound's index from
	static get_index_in = function(group_name) {
		return self.group_index[$ group_name];
	}
	
	static free = function() {
		var _arrangers = MUX_ARRANGERS;
		var _key = ds_grid_value_x(_arrangers, 0, MUX_ARR_F.NAME, ds_grid_width(_arrangers) - 1, MUX_ARR_F.NAME, self.name);
		if _key < 0 then return;
		
		var _list = _arrangers[# _key, MUX_ARR_F.STRUCT].instances;
		ds_list_delete(_list, ds_list_find_index(_list, self));
	}
}
