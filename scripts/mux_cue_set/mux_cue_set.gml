/**
 * @desc Set's an track position cue for the specified sound asset under the specified name
 * @param {Asset.GMSound} index Sound asset index
 * @param {String} cue_name The unique identifier of the cue
 * @param {Real} cue_position The position of the cue
 */
function mux_cue_set(index, cue_name, cue_position) {
	var _key = __mux_string_to_struct_key(cue_name);
	
	if not struct_exists(MUX_CUES, index)
		struct_set(MUX_CUES, index, {});
	
	MUX_CUES[$ index][$ _key] = cue_position;
}

/**
 * @desc Binds a cue collection to the specified sound asset
 * @param {Asset.GMSound} index Target sound asset index
 * @param {Struct.MuxCueCollection} cues The audio cue collection data to bind
 */
function mux_cue_set_many(index, collection) {
	struct_foreach(collection.cues, function(_name, _cue) {
		MUX_CUES[$ index][$ _name] = _cue;
	});
}

/**
 * Represents a muXica audio cue collection for a sound
 */
function MuxCueCollection() constructor {
	self.cues = {};
	self.cursor = 0;
	
	///@param {String} cue_name The unique identifier of the cue
	///@param {Real} cue_position The position of the cue
	///@param {Bool} relative Whether the specified position is absolute (false) or relative to the previous cue (true)
	///@returns {Struct.MuxCueCollection}
	add = function(cue_name, cue_position, relative = false) {
		var _key = __mux_string_to_struct_key(cue_name);
		self.cues[$ _key] = real(relative) * self.cursor + cue_position;
		self.cursor = cue_position;
		return self;
	}
}
