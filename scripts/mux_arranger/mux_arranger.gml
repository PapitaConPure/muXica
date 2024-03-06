/**
 * @desc Represents a sound arranger
 * @param {Asset.GMSound} index Sound asset index
 * @constructor
 */
function MuxArranger(index) constructor {
	self.index = index;
	self.markers = {};
	self.bpm = 130;
	self.cue_time = 0;
	self.instances = ds_list_create();
	
	/**
	 * @func jump(bars) 
	 * @desc Jumps forward the specified amount of bars, based on the current track bpm and position
	 * @param {Real} bars The number of bars to jump forward
	 */
	jump = function(bars) {
		self.cue_time += bars * time_bpm_to_seconds(self.bpm);
		return self;
	}
	
	/**
	 * @func set_marker(marker_name, marker) 
	 * @desc Sets a marker in the current track position for later access
	 * @param {String} marker_name The marker's name
	 * @param {Id.MuxMarker} marker The marker to set
	 */
	set_marker = function(marker_name, marker) {
		marker.link(self, self.cue_time);
		self.markers[$ marker_name] = marker;
		return self;
	}
	
	set_bpm = function(marker_name, bpm) {
		self.bpm = bpm;
		return self;
	}
}

/**
 * @desc Represents a position marker for a SoundArranger to use
 * @constructor
 */
function MuxMarker() constructor {
	self.handler = undefined;
	self.cue_point = 0;
	
	self.process = function() {}
	
	self.link = function(handler, cue_point) {
		self.handler = handler;
		self.cue_point = cue_point;
	}
}

/**
 * @desc Represents a jump condition marker for a SoundArranger
 * @param {Id.MuxMarker} target The SoundMarket to jump to if the condition is fulfilled
 * @param {Function} The condition to fulfill in order to perform the marker jump
 * @constructor
 */
function SoundJumpMarker(target, condition): MuxMarker() constructor {
	self.target = target;
	self.condition = condition;
	
	self.process = function() {
		if self.condition() then handler.cue_time = target.cue_point;
	}
}

function SoundLoopMarker(target): MuxMarker() constructor {
	self.target = target;
	
	self.process = function() {
		handler.cue_time = target.cue_point;
	}
}