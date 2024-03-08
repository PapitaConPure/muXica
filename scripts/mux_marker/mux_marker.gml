/**
 * @desc Represents a position marker for a SoundArranger to use
 * @constructor
 */
function MuxMarker() constructor {
	self.handler = undefined;
	self.cue_point = 0;
	self.frequency = -1;
	self.basic = true;
	
	///@desc Triggers this marker's event
	///@param {Id.MuxSound} sound The sound that triggered this marker
	///@param {Real} offset The offset between the marker's position and the sound instance's track position, in seconds
	///@param {Struct} params The parameters to consider in this cue event
	trigger_event = function(sound, offset, params) {}
	
	///@desc Links this marker to a parent MuxArranger and syncs the marker's time to it
	///@param {Id.MuxArranger} handler The MuxArranger that will act as a handler for this marker
	link = function(handler) {
		self.handler = handler;
		self.cue_point = handler.cue_time;
		self.frequency = handler.frequency;
	}
}

/**
 * @desc Represents an event marker for a MuxArranger
 * @param {Function} consecuence (sound, offset, params) The event triggered by surpassing this marker
 * @constructor
 */
function MuxEventMarker(consecuence): MuxMarker() constructor {
	self.consecuence = consecuence;
	self.basic = false;
	
	///@desc Triggers this marker's event
	///@param {Id.MuxSound} sound The sound that triggered this marker
	///@param {Real} offset The offset between the marker's position and the sound instance's track position, in seconds
	///@param {Struct} params The parameters to consider in this cue event
	trigger_event = function(sound, offset, params) {
		self.consecuence(sound, offset, params);
	}
}

/**
 * @desc Represents a event condition marker for a MuxArranger
 * @param {Function} condition (params) The condition to fulfill in order to trigger the consecuence
 * @param {Function} consecuence (sound, offset, params) The consecuence to the to fulfillment of the condition
 * @constructor
 */
function MuxConditionMarker(condition, consecuence): MuxMarker() constructor {
	self.condition = condition;
	self.consecuence = consecuence;
	self.basic = false;
	
	///@desc Triggers this marker's event
	///@param {Id.MuxSound} sound The sound that triggered this marker
	///@param {Real} offset The offset between the marker's position and the sound instance's track position, in seconds
	///@param {Struct} params The parameters to consider in this cue event
	trigger_event = function(sound, offset, params) {
		if self.condition(params) then self.consecuence(sound, offset, params);
	}
}

/**
 * @desc Represents a jump condition marker for a MuxArranger
 * @param {Function} condition (params) The condition to fulfill in order to perform the marker jump
 * @param {String} target The MuxMarker to jump to if the condition is fulfilled
 * @constructor
 */
function MuxJumpMarker(condition, target): MuxMarker() constructor {
	self.target = __mux_string_to_struct_key(target);
	self.condition = condition;
	self.basic = false;
	
	///@desc Triggers this marker's event
	///@param {Struct.MuxSound} sound The sound that triggered this marker
	///@param {Real} offset The offset between the marker's position and the sound instance's track position, in seconds
	///@param {Struct} params The parameters to consider in this cue event
	trigger_event = function(sound, offset, params) {
		if self.condition(params) then self.handler.follow_cue(sound, self, offset);
	}
}

/**
 * @desc Represents a loop marker for a MuxArranger
 * @param {String} target The MuxMarker to jump to when this marker is reached
 * @constructor
 */
function MuxLoopMarker(target): MuxMarker() constructor {
	self.target = __mux_string_to_struct_key(target);
	self.basic = false;
	
	///@desc Triggers this marker's event
	///@param {Id.MuxSound} sound The sound that triggered this marker
	///@param {Real} offset The offset between the marker's position and the sound instance's track position, in seconds
	///@param {Struct} params The parameters to consider in this cue event
	trigger_event = function(sound, offset, params) {
		self.handler.follow_cue(sound, self, offset);
	}
}

/**
 * @desc Returns a sound arranger based on the provided sound asset index
 * @param {Asset.GMSound} index
 */
function mux_arranger(index) {
	return struct_get(MUX_ARRANGERS, audio_get_name(index));
}
