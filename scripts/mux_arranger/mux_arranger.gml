enum MUX_MARKER_UNIT {
	BEATS,
	BARS,
	SECONDS,
}

enum MUX_ORD_MK {
	NAME,
	STRUCT,
}

/**
 * @desc Represents a sound arranger. It keeps track of all instances of the associated sound asset and manages them through markers.
         Each arranger has a set of arbitrary parameters to keep its sound instances in touch with the state of the game.
		 When an arranger is created, an imaginary "cursor" will be set at position 0, bpm 130, and time signature 4/4.
		 Use the set_bpm() and set_time_signature() methods to set the bpm and time_signature in the current position.
		 Use the jump_bars() and jump_beats() methods to move the cursor forward (you really shouldn't move backward).
		 Use set_marker() to set a marker in the current cursor position.
		 You can also use set_marker_repeat() to set a repeating succession of the same marker from the current cursor position.
		 You must use the finalize_markers() method or call the mux_arrangers_submit() function afterward to optimize and finalize the configuration of the arranger.
		 All associated markers must be set with set_marker() and set_marker_repeat() before finalize_markers() is called
 * @param {Asset.GMSound} index Sound asset index
 * @param {Real} start_delay Delay between the track's start and the sound's first attack, in milliseconds
 * @param {Struct} start_params Starting parameters for the arranger to work with
 * @constructor
 */
function MuxArranger(index, start_delay, start_params) constructor {
	self.index = index;
	self.params = start_params;
	self.cue_time = start_delay * 0.001;
	self.markers = {};
	self.marker_names = [];
	self.ordered_markers = undefined;
	self.instances = ds_list_create();
	self.instance_number = 0;
	self.reset_sound_delta = false;
	
	self.bpm = 130;
	self.time_signature = [ 4, 4 ];
	
	/**
	 * @desc Description
	 * @param {Real} index
	 * @returns {Struct.MuxSound}
	 */
	static get_instance = function(index) {
		return self.instances[| index];
	}
	
	///@desc Jumps forward the specified amount of beats, based on the current track bpm and position
	///@param {Real} beats The number of beats to jump forward
	static jump_beats = function(beats) {
		self.cue_time += beats * time_bpm_to_seconds(self.bpm);
		return self;
	}
	
	///@desc Jumps forward the specified amount of bars, based on the current track bpm, time signature and position
	///@param {Real} bars The number of bars to jump forward
	static jump_bars = function(bars) {
		var _beats_per_measure = self.time_signature[0];
		var _beat_note_value   = self.time_signature[1];
		self.cue_time += bars * __mux_time_bar_to_seconds(self.bpm, _beats_per_measure, _beat_note_value);
		return self;
	}
	
	///@desc Offsets the time by the specified amount of milliseconds (based only on current position, not bpm!). To account for the bpm, use jump()
	///@param {Real} bars The number of bars to jump forward
	static offset = function(ms) {
		self.cue_time += ms * 0.001;
		return self;
	}
	
	/**
	 * @desc Sets a marker in the current track position for later access
	 * @param {String} marker_name The marker's name
	 * @param {Struct.MuxMarker|Id.MuxMarker} marker The marker to set
	 */
	static set_marker = function(marker_name, marker) {
		var _key = __mux_string_to_struct_key(marker_name);
		MUX_WARN_IF struct_exists(self.markers, _key)
			__mux_warn(MUX_WARN_MARKER_DUPLICATED);
		
		marker.link(self);
		self.markers[$ _key] = marker;
		return self;
	}
	
	/**
	 * @desc Scatters a repeated marker across the described range of time for later access.
	 *       The marker's name will have a repetition index attached after a space
	 *       (from 1 to the repetition count, e.g. "my marker 1", "my marker 2", etc...)
	 * @param {String} marker_name The marker's base name
	 * @param {Real} frequency How frequently will the marker be repeated
	 * @param {Enum.MUX_MARKER_UNIT} frequency_unit The time unit of the specified frequency
	 * @param {Real} repeat_count How many times will the marker be repeated in this MuxArranger's marker registry
	 * @param {Struct.MuxMarker} marker The marker to set
	 */
	static set_marker_repeat = function(marker_name, frequency, frequency_unit, repeat_count, marker) {
		MUX_EX_IF repeat_count < 1 then __mux_ex("Invalid repeat count for marker", "A repeated markers number of repeats must be 1 or higher");
		
		var _key = __mux_string_to_struct_key(marker_name);
		MUX_WARN_IF struct_exists(self.markers, _key)
			__mux_warn(MUX_WARN_MARKER_DUPLICATED);
		
		var _repeat_key = $"{_key}_1";
		
		marker.link(self);
		self.markers[$ _repeat_key] = marker;
		
		//Determine frequency in seconds
		var _time_seconds = frequency;
		switch frequency_unit {
		case MUX_MARKER_UNIT.BARS:
			var _beats_per_measure = self.time_signature[0];
			var _beat_note_value   = self.time_signature[1];
			_time_seconds *= __mux_time_bar_to_seconds(self.bpm, _beats_per_measure, _beat_note_value);
			break;
		case MUX_MARKER_UNIT.BEATS:
			_time_seconds *= time_bpm_to_seconds(self.bpm);
			break;
		case MUX_MARKER_UNIT.SECONDS:
			break;
		default:
			if MUX_EX_ENABLE then __mux_ex("Invalid time unit", "The frequency unit must be a valid constant of MUX_MARKER_UNIT");
		}
		
		var _cue_point = self.cue_time;
		var _n = 2;
		var _copy;
		repeat repeat_count - 1 {
			_cue_point += _time_seconds;
			_repeat_key = $"{_key}_{_n++}";
			
			_copy = marker.copy();
			_copy.link(self);
			_copy.cue_point = _cue_point;
			self.markers[$ _repeat_key] = _copy;
		}
		
		return self;
	}
	
	///@desc Sets the cursor bpm to the specified amount
	///@param {Real} bpm The current section's bpm
	static set_bpm = function(bpm) {
		self.bpm = bpm;
		return self;
	}
	
	/**
	 * @desc Sets the cursor time signature to the notated value
	 * @param {Real} [beat_count] The current section's beats per measure. By default: 4
	 * @param {Real} [note_value] The current section's note value. 4 is a quarter and 8 is an eight. By default: 4
	 */
	static set_time_signature = function(beat_count = 4, note_value = 4) {
		MUX_EX_IF note_value % 4 != 0
			__mux_ex("Invalid note value", "Note value must be divisible by 4");
		self.time_signature = [beat_count, note_value];
		return self;
	}
	
	/**
	 * @desc Sets the sound instance's position to the specified track audio cue point
	 * @param {Struct.MuxSound} sound The sound which will follow the cue point
	 * @param {Struct.MuxMarker} source_marker The MuxMarker from which this follow event is occurring
	 * @param {Real} offset The delay between the marker's cue point and the moment it triggered, in seconds
	 * @param {Bool} perform_between Determines if the events between the source and the target's positions should be performed
	 * @param {String} target_name The name of the target MuxMarker as defined in the arranger. If undefined, the source marker's target will be followed instead
	 */
	static follow_cue = function(sound, source_marker, offset, perform_between, target_name = undefined) {
		if is_undefined(target_name) then target_name = source_marker.target;
		var _target_marker = self.markers[$ target_name];
		var _section_width = source_marker.cue_point - _target_marker.cue_point;
		var _new_pos = _target_marker.cue_point + ((_section_width != 0) ? (offset % _section_width) : offset);
		
		sound.set_track_position(_new_pos, perform_between ? sound.pos : -1);
		
		//Execute markers between the target marker's cue time and the offset here
		var _ordered_markers = self.ordered_markers;
		var _i = 0;
		var _size = ds_grid_width(_ordered_markers);
		repeat _size {
			var _name = ds_grid_get(_ordered_markers, _i, MUX_ORD_MK.NAME);
			var _marker = ds_grid_get(_ordered_markers, _i++, MUX_ORD_MK.STRUCT);
			
			if _marker.cue_point == source_marker.cue_point or _name == target_name then continue;
			
			if _marker.cue_point >= _new_pos then break; //Assume following markers won't be reached, as they're ordered by cue_point
			
			var _min_point = _target_marker.cue_point;
			var _max_point = _min_point + offset;
			
			if _min_point <= _marker.cue_point/* and _marker.cue_point < _max_point*/ {
				MUX_LOG_INFO($"Triggering event for residual marker \"{_name}\" in second {_marker.cue_point} ({_min_point}s <= {_marker.cue_point}s < {_max_point}s). The source marker's cue point is {source_marker.cue_point}s in, and the target marker's cue point is the min valid point");
				_marker.trigger_event(sound, offset, self.params);
			}
		}
		
		if _target_marker.cue_point <= source_marker.cue_point {
			MUX_LOG_INFO($"Triggering event for MAIN MARKER of anonymous name in second {_target_marker.cue_point}. The source marker's cue point is {source_marker.cue_point}s in");
			_target_marker.trigger_event(sound, offset, self.params);
		}
		
		return self;
	}
	
	///@desc Updates each linked sound's position and responds to track cue marker surpass events
	static update = function() {
		self.instance_number = ds_list_size(self.instances);
		if self.instance_number == 0 then return;
		
		var _ordered_markers = self.ordered_markers;
		var _size = ds_grid_width(_ordered_markers);
		var _name, _marker;
		var _snd, _j;
		var _i = 0;
		repeat self.instance_number {
			_snd = self.get_instance(_i++);
			
			_snd.update();
				
			if not _snd.updated then continue;
			
			if _snd.ppos > _snd.pos then continue;
			
			_j = 0;
			repeat _size {
				_marker = ds_grid_get(self.ordered_markers, _j++, MUX_ORD_MK.STRUCT);
				
				if _snd.ppos >= _marker.cue_point then continue;
				if _snd.pos  <  _marker.cue_point then break; //Assume following markers won't be reached by this point in time, as they're ordered by cue_point
				
				MUX_LOG_INFO($"Triggering event for \"{ds_grid_get(self.ordered_markers, _j - 1, MUX_ORD_MK.NAME)}\" in second {_marker.cue_point} ({_snd.ppos}s <= {_marker.cue_point}s < {_snd.pos}s). The source is the arranger itself");
				_marker.trigger_event(_snd, _snd.pos - _marker.cue_point, self.params);
			}
			
			_snd.post_update();
		}
	}
	
	static finalize_markers = function() {
		if not is_undefined(self.ordered_markers) and ds_exists(self.ordered_markers, ds_type_grid)
			ds_grid_destroy(self.ordered_markers);
		
		var _pq = ds_priority_create();
		var _names = struct_get_names(self.markers);
		var _size = array_length(_names);
		var _i, _name, _marker;
		
		for(_i = 0; _i < _size; _i++) {
			_name = _names[_i];
			_marker = self.markers[$ _name];
			if _marker.basic then continue;
			ds_priority_add(_pq, _name, _marker.cue_point);
		}
		
		_size = ds_priority_size(_pq);
		self.ordered_markers = ds_grid_create(_size, 2);
		for(_i = 0; _i < _size; _i++) {
			_name = ds_priority_delete_min(_pq);
			ds_grid_add(self.ordered_markers, _i, MUX_ORD_MK.NAME, _name);
			ds_grid_add(self.ordered_markers, _i, MUX_ORD_MK.STRUCT, self.markers[$ _name]);
		}
		
		ds_priority_destroy(_pq);
	}
	
	///@desc Call this to free all sound instance memory from the MuxArranger when it's no longer used
	static free = function() {
		ds_list_destroy(self.instances);
	}
}

/**
 * @desc Returns a sound arranger based on the provided sound asset index
 * @param {Asset.GMSound|Id.GMSound} index
 * @returns {Struct.MuxArranger}
 */
function mux_arranger(index) {
	var _name = audio_get_name(index);
	
	var _arrangers = MUX_ARRANGERS;
	var _index = ds_grid_value_x(_arrangers, 0, MUX_ARR_F.NAME, ds_grid_width(_arrangers) - 1, MUX_ARR_F.NAME, _name);
	
	return ds_grid_get(_arrangers, _index, MUX_ARR_F.STRUCT);
}

/**
 * @param {String} name
 * @param {Struct.MuxArranger} arranger
 */
function mux_arranger_update_all(name, arranger) {
	arranger.update();
}
