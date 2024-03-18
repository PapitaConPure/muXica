//feather ignore all

/**
 * @desc Represents a position marker for a MuxArranger to use. It has no other uses besides that
 *       None of the functions should be used outside a MuxArranger
 * @constructor
 */
function MuxMarker() constructor {
	self.handler = undefined;
	self.cue_point = 0;
	self.basic = true;
	
	/**
	 * @desc Triggers this marker's event
	 * @param {Id.MuxSound} sound The sound that triggered this marker
	 * @param {Real} offset The offset between the marker's position and the sound instance's track position, in seconds
	 * @param {Struct} params The parameters to consider in this cue event
	 */
	static trigger_event = function(sound, offset, params) {}
	
	///@desc Links this marker to a parent MuxArranger and syncs the marker's time to it
	///@param {Struct.MuxArranger|Id.Instance} handler The MuxArranger that will act as a handler for this marker
	static link = function(handler) {
		self.handler = handler;
		self.cue_point = handler.cue_time;
	}
	
	///@desc Returns an unlinked copy of this MuxMarker
	///@returns {Struct.MuxMarker}
	static copy = function() {
		var _copy = new MuxMarker();
		_copy.cue_point = self.cue_point;
		return _copy;
	}
	
	/**
	 * @desc Sets the sound instance's position to the specified track audio cue point
	 * @param {Struct.MuxSound} sound The sound which will follow the cue point
	 * @param {String} cue_name The name of the target MuxMarker as defined in the arranger
	 * @param {Real} cue_point The delay between the marker's cue point and the moment it triggered, in seconds
	 * @param {Bool} [perform_between] Determines if the events between this marker and the target marker's positions should be performed
	 */
	static follow_cue = function(sound, cue_name, offset, perform_between = false) {
		self.handler.follow_cue(sound, self, offset, perform_between, __mux_string_to_struct_key(cue_name));
	}
}

/**
 * @desc Represents an event-triggering position marker for a MuxArranger.
 *       Every time the marker's position is surpassed by an arranged sound, the specified consecuence function will be triggered, accounting for that sound's context.
 * @param {Function} consecuence (sound, offset, params) The event triggered by surpassing this marker
 * @constructor
 */
function MuxEventMarker(consecuence): MuxMarker() constructor {
	self.consecuence = consecuence;
	self.basic = false;
	
	/**
	 * @desc Triggers this marker's event
	 * @param {Id.MuxSound} sound The sound that triggered this marker
	 * @param {Real} offset The offset between the marker's position and the sound instance's track position, in seconds
	 * @param {Struct} params The parameters to consider in this cue event
	 */
	static trigger_event = function(sound, offset, params) {
		self.consecuence(self, sound, offset, params);
	}
	
	///@desc Returns an unlinked copy of this MuxEventMarker
	///@returns {Struct.MuxEventMarker}
	static copy = function() {
		var _copy = new MuxEventMarker(self.consecuence);
		_copy.cue_point = self.cue_point;
		return _copy;
	}
}

/**
 * @desc Represents a conditional event-triggering position marker for a MuxArranger.
 *       Every time the marker's position is surpassed by an arranged sound, the condition function will be evaluated.
 *       If the condition is fulfilled, the specified consecuence function will be triggered, accounting for that sound's context.
 * @param {Function} condition (params) The condition to fulfill in order to trigger the consecuence
 * @param {Function} consecuence (marker, sound, offset, params) The consecuence to the to fulfillment of the condition
 * @constructor
 */
function MuxConditionMarker(condition, consecuence): MuxMarker() constructor {
	self.condition = condition;
	self.consecuence = consecuence;
	self.basic = false;
	
	/**
	 * @desc Triggers this marker's event
	 * @param {Id.MuxSound} sound The sound that triggered this marker
	 * @param {Real} offset The offset between the marker's position and the sound instance's track position, in seconds
	 * @param {Struct} params The parameters to consider in this cue event
	 */
	static trigger_event = function(sound, offset, params) {
		if self.condition(params) then self.consecuence(self, sound, offset, params);
	}
	
	///@desc Returns an unlinked copy of this MuxMarker
	static copy = function() {
		var _copy = new MuxConditionMarker(self.condition, self.consecuence);
		_copy.cue_point = self.cue_point;
		return _copy;
	}
}

/**
 * @desc Represents a conditional jump position marker for a MuxArranger.
 *       Every time the marker's position is surpassed by an arranged sound, the condition function will be evaluated.
 *       If the condition is fulfilled, the sound will follow the position of the target marker (specified by name).
 *       If perform_between is set to true, all markers between this one and the target will be processed in between
 * @param {Function} condition (params) The condition to fulfill in order to perform the marker jump
 * @param {String} target The MuxMarker to jump to if the condition is fulfilled
 * @constructor
 */
function MuxJumpMarker(condition, target, perform_between = false): MuxMarker() constructor {
	self.target = __mux_string_to_struct_key(target);
	self.condition = condition;
	self.basic = false;
	self.perform_between = false;
	
	/**
	 * @desc Triggers this marker's event
	 * @param {Struct.MuxSound} sound The sound that triggered this marker
	 * @param {Real} offset The offset between the marker's position and the sound instance's track position, in seconds
	 * @param {Struct} params The parameters to consider in this cue event
	 */
	static trigger_event = function(sound, offset, params) {
		if self.condition(params) then self.handler.follow_cue(sound, self, offset, self.perform_between);
	}
	
	///@desc Returns an unlinked copy of this MuxMarker
	static copy = function() {
		var _copy = new MuxJumpMarker(self.condition, self.target);
		_copy.cue_point = self.cue_point;
		return _copy;
	}
}

/**
 * @desc Represents a loop jump position marker for a MuxArranger.
 *       Every time a sound surpasses the marker's position, it will follow the position of the target marker (specified by name).
 *       This can also be used to unconditionally skip a certain section of a sound
 * @param {String} target The MuxMarker to jump to when this marker is reached
 * @constructor
 */
function MuxLoopMarker(target): MuxMarker() constructor {
	self.target = __mux_string_to_struct_key(target);
	self.basic = false;
	
	/**
	 * @desc Triggers this marker's event
	 * @param {Struct.MuxSound} sound The sound that triggered this marker
	 * @param {Real} offset The offset between the marker's position and the sound instance's track position, in seconds
	 * @param {Struct} params The parameters to consider in this cue event
	 */
	static trigger_event = function(sound, offset, params) {
		self.handler.follow_cue(sound, self, offset, false);
	}
	
	///@desc Returns an unlinked copy of this MuxMarker
	static copy = function() {
		var _copy = new MuxLoopMarker(self.target);
		_copy.cue_point = self.cue_point;
		return _copy;
	}
}
