/**
 * @desc Set's an track position cue for the specified sound asset under the specified name
 * @param {Asset.GMSound} index 
 * @param {String} cue_name 
 * @param {Real} cue_position 
 */
function mux_cue_set(index, cue_name, cue_position) {
	var _key = __mux_string_to_struct_key(cue_name);
	
	if not struct_exists(MUX_CUES, index)
		struct_set(MUX_CUES, index, {});
	
	MUX_CUES[$ index][$ _key] = cue_position;
}

/**
 * @desc 
 * @param {Asset.GMSound} index
 * @param {Id.MuxCueCollection} cues
 */
function mux_cue_set_many(index, collection) {
	struct_foreach(collection.cues, function(_name, _cue) {
		MUX_CUES[$ index][$ _name] = _cue;
	});
}

function MuxCueCollection() constructor {
	self.cues = {};
	self.cursor = 0;
	
	add = function(cue_name, cue_position, relative = false) {
		var _key = __mux_string_to_struct_key(cue_name);
		self.cues[$ _key] = real(relative) * self.cursor + cue_position;
		self.cursor = cue_position;
	}
}
