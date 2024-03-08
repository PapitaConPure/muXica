/**
 * @desc Represents a sound arranger
 * @param {Asset.GMSound} index Sound asset index
 * @param {Real} start_delay Delay between the track's start and the sound's first attack, in milliseconds
 * @param {Struct} start_params Starting parameters for the arranger to work with
 * @constructor
 */
function MuxArranger(index, start_delay, start_params) constructor {
	self.index = index;
	self.markers = {};
	self.params = start_params;
	self.cue_time = start_delay * 0.001;
	self.instances = ds_list_create();
	self.instance_number = 0;
	
	self.frequency = -1;
	self.bpm = 130;
	self.time_signature = [4, 4];
	
	/**
	 * @desc Jumps forward the specified amount of beats, based on the current track bpm and position
	 * @param {Real} beats The number of beats to jump forward
	 */
	jump_beats = function(beats) {
		self.cue_time += beats * time_bpm_to_seconds(self.bpm);
		return self;
	}
	
	/**
	 * @desc Jumps forward the specified amount of bars, based on the current track bpm, time signature and position
	 * @param {Real} bars The number of bars to jump forward
	 */
	jump_bars = function(bars) {
		var _beats_per_measure = self.time_signature[0];
		var _beat_note_value   = self.time_signature[1];
		self.cue_time += bars * __mux_time_bar_to_seconds(self.bpm, _beats_per_measure, _beat_note_value);
		return self;
	}
	
	/**
	 * @desc Offsets the time by the specified amount of milliseconds (based only on current position, not bpm!). To account for the bpm, use jump()
	 * @param {Real} bars The number of bars to jump forward
	 */
	offset = function(ms) {
		self.cue_time += ms * 0.001;
		return self;
	}
	
	/**
	 * @desc Sets a marker in the current track position for later access
	 * @param {String} marker_name The marker's name
	 * @param {Struct.MuxMarker|Id.MuxMarker} marker The marker to set
	 */
	set_marker = function(marker_name, marker) {
		marker.link(self);
		var _key = __mux_string_to_struct_key(marker_name);
		self.markers[$ _key] = marker;
		return self;
	}
	
	/**
	 * @desc Sets the cursor bpm to the specified amount
	 * @param {Real} bpm The current section's bpm
	 */
	set_bpm = function(bpm) {
		self.bpm = bpm;
		return self;
	}
	
	/**
	 * @desc Sets the cursor time signature to the notated value
	 * @param {Real} [beat_count] The current section's beats per measure. By default: 4
	 * @param {Real} [note_value] The current section's note value. 4 is a quarter and 8 is an eight. By default: 4
	 */
	set_time_signature = function(beat_count = 4, note_value = 4) {
		if MUX_EX_ENABLE and note_value % 4 != 0
			__mux_ex("Invalid note value", "Note value must be divisible by 4");
		self.time_signature = [beat_count, note_value];
		return self;
	}
	
	/**
	 * @desc Sets the frequency by which subsequent cue markers will trigger
	 * @param {Real} frequency The subsequent marker frequency value (in events per bar). 0 means no frequency at all, which is the default
	 */
	set_frequency = function(frequency = 0) {
		self.frequency = frequency;
		return self;
	}
	
	self.__followed_cue_data = {};
	/**
	 * @desc Sets the sound instance's position to the specified track audio cue point
	 * @param {Struct.MuxSound} sound The sound which will follow the cue point
	 * @param {Struct.MuxMarker} source_marker The MuxMarker from which this follow event is occurring
	 * @param {Real} cue_point The delay between the marker's cue point and the moment it triggered, in seconds
	 */
	follow_cue = function(sound, source_marker, offset) {
		var _target_marker = self.markers[$ source_marker.target];
		var _section_width = source_marker.cue_point - _target_marker.cue_point;
		var _new_pos = _target_marker.cue_point + offset % _section_width;
		
		if _new_pos != 0 then sound.__trap_pos = true;
		audio_sound_set_track_position(sound.inst, _new_pos);
		
		//Execute markers between the target marker's cue time and the offset here
		self.__followed_cue_data = {
			sound, offset,
			target: source_marker.target,
			source_cue: source_marker.cue_point,
			cue_point: _target_marker.cue_point
		};
		
		struct_foreach(self.markers, function(name, marker) {
			var _data = self.__followed_cue_data;
			
			if name == _data.target or marker.cue_point == _data.source_cue then return;
			
			var _sound = _data.sound;
			if marker.cue_point >= _sound.pos then return;
			
			show_debug_message(name);
			
			var _cue_point = _data.cue_point;
			var _offset = _data.offset;
			var _max_point = _cue_point + _offset;
			
			if _cue_point <= marker.cue_point and marker.cue_point < _max_point
				marker.trigger_event(_sound, _offset, self.params);
		});
		_target_marker.trigger_event(sound, offset, self.params);
		
		return self;
	}
	
	/**
	 * @desc Updates each linked sound's position and responds to track cue marker surpass events
	 */
	update = function() {
		self.instance_number = ds_list_size(self.instances);
		
		var _i = 0;
		repeat self.instance_number {
			self.instances[| _i++].update();
		}
		
		struct_foreach(self.markers, function(marker_name, marker) {
			if marker.basic then return;
			
			var _snd, _i = 0;
			repeat self.instance_number {
				_snd = self.instances[| _i++];
				
				if _snd.ppos > _snd.pos then continue;
				
				if _snd.ppos >= marker.cue_point or _snd.pos < marker.cue_point then continue;
				
				show_debug_message($"{_snd.inst} {_snd.ppos} < [{marker.cue_point}] < {_snd.pos}");
				
				marker.trigger_event(_snd, _snd.pos - marker.cue_point, self.params);
			}
		});
	}
	
	/**
	 * @desc Call this to free all sound instance memory from the MuxArranger when it's no longer used
	 */
	free = function() {
		ds_list_destroy(self.instances);
	}
}