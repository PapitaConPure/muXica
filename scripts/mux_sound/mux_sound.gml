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
	
	self.__trap_pos = true;
	
	//Automatically attach to handler's corresponding MuxArranger if it exists (for cue event handling magic)
	var _key = audio_get_name(index);
	if struct_exists(MUX_ARRANGERS, _key)
		ds_list_add(MUX_ARRANGERS[$ _key].instances, self);
	
	self.update = function() {
		self.ppos = self.pos;
		
		var _new_pos = audio_sound_get_track_position(self.inst);
		if _new_pos == 0 and self.__trap_pos then return;
		self.pos = _new_pos;
		self.__trap_pos = false;
	}
}
