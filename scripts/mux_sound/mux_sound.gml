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
	self.group = audio_sound_get_audio_group(index);
	self.length = audio_sound_length(index);
	
	self.__trap_pos = false;
	self.__reset_ppos = -1;
	
	//Automatically attach to handler's corresponding MuxArranger if it exists (for cue event handling magic)
	var _key = audio_get_name(index);
	if struct_exists(MUX_ARRANGERS, _key)
		ds_list_add(MUX_ARRANGERS[$ _key].instances, self);
	
	self.update = function() {
		if self.__reset_ppos < 0 {
			self.ppos = self.pos;
		} else {
			self.ppos = self.__reset_ppos;
			self.__reset_ppos = -1;
		}
		
		var _new_pos = audio_sound_get_track_position(self.inst);
		if _new_pos == 0 and self.__trap_pos {
			//Some weird error has occurred. Approximate as best as possible
			var _leeway = 1.8;
			var _half_range = delta_time * 0.000001 * _leeway;
			var _diff = self.pos - self.ppos;
			_diff = clamp(_diff, -_half_range, _half_range);
			self.pos += _diff;
			self.__trap_pos = false;
			return;
		}
		self.pos = _new_pos;
	}
	
	///@param {Real} position The new track position for this sound instance, in seconds
	self.set_track_position = function(position) {
		audio_sound_set_track_position(self.inst, position)
		self.ppos = self.pos;
		self.pos = position;
	}
}
