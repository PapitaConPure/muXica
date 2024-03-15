#macro AUDIO_STARTUP_TIME 4

/// @param {Asset.GMSound} sound_index New sound index
/// @param {Real} priority New sound priority
/// @param {Bool} [loop] New sound loop mode (false by default)
/// @param {Real} [gain] New sound gain (1 by default)
/// @param {Real} [offset] New sound offset (in seconds, defaults to 0)
/// @param {Real} [pitch] New sound pitch (1 by default)
/// @param {Real} [listener_mask] New sound listener bit-mask. Unused on the HTML5 target
/// @returns {Id.Sound}
function mux_sound_play(index, priority, loop = false, gain = 1, offset = 0, pitch = 1, listener_mask = undefined) {
	MUX_CHECK_UNINITIALISED_EX;
	
	var _audio_group = audio_sound_get_audio_group(index);
	if MUX_EX_ENABLE and _audio_group == audiogroup_default
		__mux_ex("Tried to play a sound from an unregistered audio group", "The requested sound to play wasn't from an audio group that muXica registered beforehand");
	var _group_key = audio_group_name(_audio_group);
	var _group_bank = mux_handler_get_group(_group_key);
	
	var _gain = mux_group_gain(_audio_group, gain);
	var _id = audio_play_sound(index, priority, loop, _gain, offset, pitch, listener_mask);
	var _sound = new MuxSound(index, _id);
	_group_bank.add_sound(_sound);
	MUX_ALL.add_sound(_sound);
	return _id;
}

/**
 * @desc Crossfades from the playing audio to the new audio within the specified time frame
 * @param {Real} time Time for transition (in milliseconds)
 * @param {Id.Sound|Constant.All} from Origin existing sound id
 * @param {Asset.GMSound} to Destination sound index
 * @param {Real} priority New sound priority
 * @param {Bool} [loop] New sound loop mode (false by default)
 * @param {Bool} [synced] New sound sync mode (false by default)
 * @param {Real} [gain] New sound gain (1 by default)
 * @param {Real} [offset] New sound offset (in seconds, defaults to 0)
 * @param {Real} [pitch] New sound pitch (1 by default)
 * @param {Real} [listener_mask] New sound listener bit-mask. Unused on the HTML5 target
 * @returns {Id.Sound}
 */
function mux_sound_crossfade(time, from, to, priority, loop = false, synced = false, gain = 1, offset = 0, pitch = 1, listener_mask = undefined) {
	MUX_CHECK_UNINITIALISED_EX;
	
	var _audio_group = audio_sound_get_audio_group(to);
	var _gain = mux_group_gain(_audio_group, gain);
	var _group_key = audio_group_name(_audio_group);
	var _group_bank = mux_handler_get_group(_group_key);
	var _all_bank   = MUX_ALL;
	
	if from == all {
		__mux_sound_fade_out_group(time, _group_bank, _all_bank);
		var _id = audio_play_sound(to, priority, loop, 0, offset, pitch, listener_mask);
		__mux_sound_crossfade_delayed(undefined, _id, _gain, time);
		var _sound = new MuxSound(to, _id);
		_group_bank.add_sound(_sound);
		_all_bank.add_sound(_sound);
		return _id;
	}
	
	var _old_group_idx = mux_sound_get_inst_group_index(_group_bank, from);
	var _old_all_idx = mux_sound_get_inst_group_index(_all_bank, from);
	var _id = audio_play_sound(to, priority, loop, 0, offset, pitch, listener_mask);
	__mux_sound_crossfade_delayed(from, _id, _gain, time);
	
	var _source_position = audio_sound_get_track_position(from);
	var _relative_position = __mux_wrap(_source_position, 0, audio_sound_length(to), true);
	if synced then audio_sound_set_track_position(_id, _relative_position);
	
	var _old_sound = _all_bank.get_sound(_old_all_idx);
	var _sound = new MuxSound(to, _id);
	_group_bank.replace_sound_at(_old_group_idx, _sound);
	_all_bank.replace_sound_at(_old_all_idx, _sound);
	MUX_P_STOP.add_sound(_old_sound);
	return _id;
}

/**
 * @desc Crossfades from the playing audio to the new audio within the specified time frame
 * @param {Asset.GMSound|Id.Sound|Constant.All} sound Origin existing sound id
 * @param {Real} time Time for transition (in milliseconds)
 */
function mux_sound_stop(sound, time = 0) {
	MUX_CHECK_UNINITIALISED_EX;
	
	var _all_bank = MUX_ALL;
	
	if sound == all {
		__mux_sound_fade_out_all(time, _all_bank)
		return;
	}
	
	if not audio_exists(sound) then return;
	
	var _group_key = audio_group_name(audio_sound_get_audio_group(sound));
	var _group_bank = mux_handler_get_group(_group_key);
	
	if typeof(sound) == "ref" {
		__mux_sound_fade_out_index(time, sound, _group_bank, _all_bank);
	} else {
		var _group_idx = _group_bank.find_index_of(sound);
		var _stopped_sound = _group_bank.get_sound(_group_idx);
		var _all_idx = _stopped_sound.get_index_in("all");
		
		audio_sound_gain(sound, 0, time);
		_group_bank.remove_sound_at(_group_idx);
		_all_bank.remove_sound_at(_all_idx);
		MUX_P_STOP.add_sound(_stopped_sound);
	}
}

/**
 * @desc Crossfades in and out the respective sound instances. If you want to avoit throttling issues, try changing the frame delay to something higher (default=1)
 * @param {Id.Sound|Undefined} _out
 * @param {Id.Sound} _in
 * @param {Real} _time
 */
function __mux_sound_crossfade_delayed(_out, _in, _gain, _time) {
	MUX_LOG_INFO($"Crossfade [{is_undefined(_out) ? "ANY" : $"{audio_get_name(_in)}/{_in}"}]->[{audio_get_name(_in)}/{_in}] has been requested and will commence in {_time} frames");
	
	//Set up next crossfade event
	var _handler = MUX_HANDLER;
	_handler.timer_crossfade[_handler.timer_crossfade_n++] = MUX_CROSSFADE_DELAY;
	ds_queue_enqueue(MUX_P_FADE, { in: _in, out: _out, gain: _gain, time: _time });
}

/**
 * @param {Real} time
 * @param {Struct.MuxGroup} all_bank
 */
function __mux_sound_fade_out_all(time, all_bank) {
	var _start = all_bank.size - 1;
	var _found, _found_idx, _i;
	
	for(_i = _start; _i >= 0; _i--) {
		if not all_bank.has_sound(_i) then continue;
		
		_found = all_bank.get_sound(_i);
		audio_sound_gain(_found.inst, 0, time);
		all_bank.remove_sound_at(_i);
		MUX_P_STOP.add_sound(_found);
	}
	
	MUX_BGM.flush();
	MUX_SFX.flush();
}

/**
 * Crossfades out all registered sounds within the specified group bank
 * @param {Real} time
 * @param {Struct.MuxGroup} group_bank
 * @param {Struct.MuxGroup} all_bank
 */
function __mux_sound_fade_out_group(time, group_bank, all_bank) {
	var _start = all_bank.size - 1;
	var _found, _found_idx, _i;
	
	for(_i = _start; _i >= 0; _i--) {
		if not all_bank.has_sound(_i) then continue;
		
		_found = all_bank.get_sound(_i);
		audio_sound_gain(_found.inst, 0, time);
		group_bank.remove_sound(_found);
		all_bank.remove_sound_at(_i);
		MUX_P_STOP.add_sound(_found);
	}
}

/**
 * Crossfades out all registered sounds whose source is the specified index
 * @param {Real} time
 * @param {Asset.GMSound} index
 * @param {Struct.MuxGroup} group_bank
 * @param {Struct.MuxGroup} all_bank
 */
function __mux_sound_fade_out_index(time, index, group_bank, all_bank) {
	var _start = all_bank.size - 1;
	var _found, _found_idx, _i;
	
	for(_i = _start; _i >= 0; _i--) {
		if not all_bank.has_sound(_i) then continue;
		
		_found = all_bank.get_sound(_i);
		if _found.index != index then continue;
		
		audio_sound_gain(_found.inst, 0, time);
		group_bank.remove_sound(_found);
		all_bank.remove_sound_at(_i);
		MUX_P_STOP.add_sound(_found);
	}
}
