/**
 * @desc Represents an audio instance block, containing both the sound asset index and the sound instance id, as well as additional information about the asset or instance.
 *       It is part of the MuxArranger system, so it has little use if using the standalone cues system. It has the update() and post_update() methods for processing.
 *       You should never call the free() method manually, as all instances related to an arranger will be freed when the arranger is freed, and all other instances don't need to be freed
 * @param {Asset.GMSound} index Sound asset index
 * @param {Id.Sound} inst Sound instance id
 * @param {Id.AudioEmitter} inst Audio emitter id
 * @param {Bool} arranged Whether this instance should be managed by an associated MuxArranger (if any) (true, default) or not (false)
 * @constructor
 */
function MuxSound(index, inst, emitter, arranged = true) constructor {
	self.index = index;
	self.inst = inst;
	self.emitter = emitter;
	self.arranged = arranged;
	
	self.pos = audio_sound_get_track_position(inst);
	self.ppos = self.pos;
	self.playing = true;
	self.stopped = false;
	self.updated = false;
	self.looping = audio_sound_get_loop(inst);
	self.pitch = audio_sound_get_pitch(inst);
	
	self.name = audio_get_name(index);
	self.group = audio_sound_get_audio_group(index);
	self.length = audio_sound_length(index);
	
	self.bank_index = {};
	
	self.__reset_ppos = -1;
	self.__next_pos = -1;
	
	//Automatically attach to handler's corresponding MuxArranger if it exists (for cue event handling magic)
	if self.arranged {
		var _arrangers = MUX_ARRANGERS;
		var _key = ds_grid_value_x(_arrangers, 0, MUX_ARR_F.NAME, ds_grid_width(_arrangers) - 1, MUX_ARR_F.NAME, self.name);
		
		if _key >= 0 {
			ds_list_add(_arrangers[# _key, MUX_ARR_F.STRUCT].instances, self);
		} else {
			self.arranged = false;
		}
	}
	
	///@desc Updates the sound instance's track position over time. Also keeps track of the previous position
	///      If the sound's position is different for this frame, the "updated" variable will be set to true, otherwise it will be set to false
	static update = function() {
		self.updated = false;
		if not self.playing then return;
		
		//I'll sync it my-fucking-self
		var _new_pos = self.pos + self.get_pitch_delta_factor();
		
		if _new_pos >= self.length {
			if self.looping {
				self.ppos = 0;
				_new_pos -= self.length;
			} else {
				self.stop();
				return;
			}
		} else {
			if self.__reset_ppos < 0 {
				self.ppos = self.pos;
			} else {
				self.ppos = self.__reset_ppos;
				self.__reset_ppos = -1;
			}
		}
		
		self.pos = _new_pos;
		self.updated = true;
	}
	
	///@desc Applies position changes after a manual track position change
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
	
	///@desc Sets the sound instance's pitch/speed
	///@param {Real} pitch Pitch of the sound, where 1 is normal pitch
	static set_pitch = function(pitch) {
		audio_sound_pitch(self.inst, pitch);
		self.pitch = pitch;
	}
	
	///@desc Pauses the sound instance's playback
	static pause = function() {
		audio_pause_sound(self.inst);
		self.playing = false;
	}
	
	///@desc Resumes the sound instance's playback
	static resume = function() {
		audio_resume_sound(self.inst);
		self.playing = true;
	}
	
	///@desc Stops the sound instance's playback and frees the sound block from its associated arranger (if any)
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
	
	///@desc Indexes a bank for this sound, keeping track of this sound's position within the bank specified by name
	///@param {String} bank_name The name of the bank this sound will be linked to
	///@param {Real} bank_index The internal index this sound will occupy within the bank
	static add_index = function(bank_name, bank_index) {
		self.bank_index[$ bank_name] = bank_index;
	}
	
	///@desc Removes the specified bank index entry for this sound
	///@param {String} bank_name The name of the bank this sound will be unlinked from
	static remove_index = function(bank_name) {
		self.bank_index[$ bank_name] = undefined;
	}
	
	///@desc Gets the sound's position within the bank specified by name
	///@param {String} bank_name The name of the bank to get the sound's index from
	static get_index_in = function(bank_name) {
		return self.bank_index[$ bank_name];
	}
	
	///@desc Gets the delta-adjusted pitch factor for this sound instance, based on the sound instance and audio emitter's pitches
	///@returns {Real}
	static get_pitch_delta_factor = function() {
		var _delta_fac = delta_time * 0.000001;
		return _delta_fac * self.get_pitch_factor();
	}
	
	///@desc Gets the pitch factor for this sound instance, based on the sound instance and audio emitter's pitches
	///@returns {Real}
	static get_pitch_factor = function() {
		var _emitter_pitch = audio_emitter_exists(self.emitter) ? audio_emitter_get_pitch(self.emitter) : 1;
		return self.pitch * _emitter_pitch;
	}
	
	///@desc Unlinks this sound from its associated arranger (if any) and frees up the sound block's resources
	static free = function() {
		if not self.arranged then return;
		
		var _arrangers = MUX_ARRANGERS;
		var _key = ds_grid_value_x(_arrangers, 0, MUX_ARR_F.NAME, ds_grid_width(_arrangers) - 1, MUX_ARR_F.NAME, self.name);
		if _key < 0 then return;
		
		var _list = _arrangers[# _key, MUX_ARR_F.STRUCT].instances;
		ds_list_delete(_list, ds_list_find_index(_list, self));
	}
}
