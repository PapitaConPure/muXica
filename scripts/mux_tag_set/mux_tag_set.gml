/**
 * @desc Registers a new audio tag space with the specified name in the muXica system
 * @param {String} tag The new tag's name
 */
function mux_tag_create(tag) {
	MUX_CHECK_STRING_INVALID_EX;
		
	var _key = __mux_string_to_struct_key(tag);
	
	MUX_WARN_IF(variable_struct_exists(MUX_TAGS, _key))
		__mux_warn($"The tag \"{tag}\" already exists")
		
	MUX_TAGS[$ _key] = [];
}

/**
 * @desc Adds the indicated sound asset to this audio tag space
 * @param {String} tag The tag's name
 * @param {Asset.GMSound} sound The sound asset to add to this tag space
 */
function mux_tag_add(tag, sound) {
	MUX_CHECK_STRING_INVALID_EX;
	
	var _key = __mux_string_to_struct_key(tag);
	
	MUX_WARN_IF(not variable_struct_exists(MUX_TAGS, _key))
		__mux_ex("Unknown tag", $"The tag \"{tag}\" hasn't been registered in the muXica system before accesing it");
	
	MUX_EX_IF(typeof(sound) != "ref" or not audio_exists(sound))
		__mux_ex("Invalid sound", "You must specify a valid sound asset to add to the tag space");
	
	array_push(MUX_TAGS[$ _key], sound);
}

/**
 * @desc Creates a new audio tag space and adds the indicated sound assets to it
 * @param {String} tag The tag's name
 * @param {Array<Asset.GMSound>} sounds An array of sound assets to add to this tag space
 */
function mux_tag_set(tag, sounds) {
	mux_tag_create(tag);
	
	var _i = 0;
	var _l = array_length(sounds);
	repeat _l mux_tag_add(tag, sounds[_i++]);
}
