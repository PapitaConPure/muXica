/**
 * @desc Represents a sound arranger
 * @param {Asset.GMSound} index Sound asset index
 * @param {Real} [start_delay] Delay between the track's start and the sound's first attack, in milliseconds
 * @constructor
 */
function MuxArranger(index, start_delay = 0) constructor {
	self.index = index;
	self.markers = {};
	self.frequency = -1;
	self.bpm = 130;
	self.cue_time = start_delay * 0.001;
	self.instances = ds_list_create();
	self.instance_number = 0;
	self.params = {};
	
	/**
	 * @desc Jumps forward the specified amount of bars, based on the current track bpm and position
	 * @param {Real} bars The number of bars to jump forward
	 */
	jump = function(bars) {
		self.cue_time += bars * time_bpm_to_seconds(self.bpm);
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
	 * @param {Id.MuxMarker} marker The marker to set
	 * @return {Struct.MuxArranger}
	 */
	set_marker = function(marker_name, marker) {
		marker.link(self);
		self.markers[$ marker_name] = marker;
		return self;
	}
	
	/**
	 * @desc Sets the cursor bpm to the specified amount
	 * @param {Real} bpm The current section's bpm
	 * @return {Struct.MuxArranger}
	 */
	set_bpm = function(bpm) {
		self.bpm = bpm;
		return self;
	}
	
	/**
	 * @desc Sets the cursor time signature to the notated value
	 * @param {Real} [beat_count] The current section's beats per measure. By default: 4
	 * @param {Real} [note_value] The current section's note value. 4 is a quarter and 8 is an eight. By default: 4
	 * @return {Struct.MuxArranger}
	 */
	set_time_signature = function(beat_count = 4, note_value = 4) {
		self.bpm = bpm;
		return self;
	}
	
	/**
	 * @desc Sets the frequency by which subsequent cue markers will trigger
	 * @param {Real} frequency The subsequent marker frequency value (in events per bar). 0 means no frequency at all, which is the default
	 * @return {Struct.MuxArranger}
	 */
	set_frequency = function(frequency = 0) {
		self.frequency = frequency;
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
				
				if _snd.ppos < marker.cue_point and _snd.pos >= marker.cue_point
					marker.process(_snd.pos - _snd.ppos, self.params);
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

/**
 * @desc Represents a position marker for a SoundArranger to use
 * @constructor
 */
function MuxMarker() constructor {
	self.handler = undefined;
	self.cue_point = 0;
	self.frequency = -1;
	self.basic = true;
	
	self.process = function(offset, params) {}
	
	self.link = function(handler, cue_point) {
		self.handler = handler;
		self.cue_point = handler.cue_time;
		self.frequency = handler.frequency;
	}
}

/**
 * @desc Represents an event marker for a MuxArranger
 * @param {Function} consecuence (offset, params) The event triggered by surpassing this marker
 * @constructor
 */
function MuxEventMarker(consecuence): MuxMarker() constructor {
	self.consecuence = consecuence;
	self.basic = false;
	
	self.process = function(offset, params) {
		self.consecuence(offset, params);
	}
}

/**
 * @desc Represents a event condition marker for a MuxArranger
 * @param {Function} condition (params) The condition to fulfill in order to trigger the consecuence
 * @param {Function} consecuence (offset, params) The consecuence to the to fulfillment of the condition
 * @constructor
 */
function MuxConditionMarker(condition, consecuence): MuxMarker() constructor {
	self.condition = condition;
	self.consecuence = consecuence;
	self.basic = false;
	
	self.process = function(offset, params) {
		if self.condition(params) then self.consecuence(offset, params);
	}
}

/**
 * @desc Represents a jump condition marker for a MuxArranger
 * @param {Function} condition The condition to fulfill in order to perform the marker jump
 * @param {Id.MuxMarker} target The MuxMarker to jump to if the condition is fulfilled
 * @constructor
 */
function MuxJumpMarker(condition, target): MuxMarker() constructor {
	self.target = target;
	self.condition = condition;
	self.basic = false;
	
	self.process = function(offset, params) {
		if self.condition() then self.handler.cue_time = self.target.cue_point;
	}
}

/**
 * @desc Represents a loop marker for a MuxArranger
 * @param {Id.MuxMarker} target The MuxMarker to jump to when this marker is reached
 * @constructor
 */
function MuxLoopMarker(target): MuxMarker() constructor {
	self.target = target;
	self.basic = false;
	
	self.process = function(offset, params) {
		self.handler.cue_time = self.target.cue_point;
	}
}

/**
 * @desc Returns a sound arranger based on the provided sound asset index
 * @param {Asset.GMSound} index
 */
function mux_arranger(index) {
	return struct_get(MUX_ARRANGERS, audio_get_name(index));
}
