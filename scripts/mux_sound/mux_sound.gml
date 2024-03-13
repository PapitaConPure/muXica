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
	self.updated = false;
	self.group = audio_sound_get_audio_group(index);
	self.length = audio_sound_length(index);
	self.playing = true;
	
	self.__trap_pos = false;
	self.__reset_ppos = -1;
	self.__next_pos = -1; //Why is GameMaker like this
	
	//Automatically attach to handler's corresponding MuxArranger if it exists (for cue event handling magic)
	var _key = audio_get_name(index);
	if struct_exists(MUX_ARRANGERS, _key)
		ds_list_add(MUX_ARRANGERS[$ _key].instances, self);
	
	self.update = function() {
		self.updated = false;
		
		//Actually, fuck GameMaker's audio support. I'll sync it my-fucking-self
		var _new_pos = self.pos + delta_time * 0.000001;//audio_sound_get_track_position(self.inst);
		if _new_pos == self.pos then return;
		
		if self.__reset_ppos < 0 {
			self.ppos = self.pos;
		} else {
			self.ppos = self.__reset_ppos;
			self.__reset_ppos = -1;
		}
		
		/*if self.__trap_pos and self.pos < _new_pos
			self.__trap_pos = false;
		
		if _new_pos == 0 and self.__trap_pos {
			//Some weird error has occurred. Approximate as best as possible
			//var _leeway = 1.8;
			//var _half_range = delta_time * 0.000001 * _leeway;
			//var _diff = self.pos - self.ppos;
			//_diff = clamp(_diff, -_half_range, _half_range);
			//self.pos += _diff;
			return;
		}*/
		
		self.pos = _new_pos;
		self.updated = true;
	}
	
	self.post_update = function() {
		if self.__next_pos < 0 then return;
		self.pos = self.__next_pos;
		self.__next_pos = -1;
	}
	
	///@param {Real} position The new track position for this sound instance, in seconds
	///@param {Real} [reset_ppos] Whether to reset the previous track position to a certain time (in seconds, 0 or higher) or leave it as it was (-1)
	self.set_track_position = function(position, reset_ppos = -1) {
		audio_sound_set_track_position(self.inst, position)
		
		if position != 0 then self.__trap_pos = true;
		audio_sound_set_track_position(self.inst, position);
		self.__reset_ppos = reset_ppos;
		self.__next_pos = position;
	}
	
	self.pause = function() {
		audio_pause_sound(self.inst);
		self.playing = false;
	}
	
	self.resume = function() {
		audio_resume_sound(self.inst);
		self.playing = true;
	}
}
