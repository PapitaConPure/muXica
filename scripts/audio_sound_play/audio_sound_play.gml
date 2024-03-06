#macro AUDIO_STARTUP_TIME 4

/// @param {Asset.GMSound} sound_index New sound index
/// @param {Real} priority New sound priority
/// @param {Bool} [loop] New sound loop mode
/// @param {Real} [gain] New sound gain
/// @returns {Id.Sound}
function audio_sound_play(index, priority, loop = false, gain = 1) {
	MUX_CHECK_UNINITIALISED_EX;
	
	var _group_key = audio_group_name(audio_sound_get_audio_group(index));
	var _group_bank = MUX_GROUPS[$ _group_key];
	
	var _id = audio_play_sound(index, priority, loop);
	audio_sound_gain(_id, gain, 0);
	var _sound = new Sound(index, _id);
	ds_list_add(_group_bank, _sound);
	ds_list_add(MUX_ALL, _sound);
	return _id;
}

/**
 * @desc Crossfades from the playing audio to the new audio within the specified time frame
 * @param {Real} time Time for transition (in milliseconds)
 * @param {Id.Sound|Constant.All} from Origin existing sound id
 * @param {Asset.GMSound} to Destination sound index
 * @param {Real} priority New sound priority
 * @param {Bool} [loop] New sound loop mode
 * @param {Bool} [synced] New sound sync mode
 * @returns {Id.Sound}
 */
function audio_sound_crossfade(time, from, to, priority, loop = false, synced = false) {
	MUX_CHECK_UNINITIALISED_EX;
	
	var _group_key = audio_group_name(audio_sound_get_audio_group(to));
	var _group_bank = MUX_GROUPS[$ _group_key];
	var _all_bank   = MUX_ALL;
	
	if from == all {
		__mux_sound_fade_out_group(time, _group_bank, _all_bank);
		var _id = audio_play_sound(to, priority, loop);
		__mux_sound_crossfade_delayed(undefined, _id, time);
		var _sound = new Sound(to, _id);
		ds_list_add(_group_bank, _sound);
		ds_list_add(_all_bank,   _sound);
		return _id;
	}
	
	var _old_group_idx = audio_sound_get_inst_bank_index(_group_bank, from);
	var _old_all_idx = audio_sound_get_inst_bank_index(_all_bank, from);
	var _id = audio_play_sound(to, priority, loop);
	__mux_sound_crossfade_delayed(from, _id, time);
	
	var _source_position = audio_sound_get_track_position(from);
	var _relative_position = wrap(_source_position, 0, audio_sound_length(to), true);
	if synced then audio_sound_set_track_position(_id, _relative_position);
	
	var _sound = new Sound(to, _id);
	ds_list_replace(_group_bank, _old_group_idx, _sound);
	ds_list_replace(_all_bank,   _old_all_idx,   _sound);
	ds_list_add(MUX_P_STOP, from);
	return _id;
}

/**
 * @desc Crossfades from the playing audio to the new audio within the specified time frame
 * @param {Asset.GMSound|Id.Sound|Constant.All} sound Origin existing sound id
 * @param {Real} time Time for transition (in milliseconds)
 */
function audio_sound_stop(sound, time) {
	MUX_CHECK_UNINITIALISED_EX;
	
	var _all_bank = MUX_ALL;
	
	if sound == all {
		__mux_sound_fade_out_all(time, _all_bank)
		return;
	}
	
	if not audio_exists(sound) then return;
	
	var _group_key = audio_group_name(audio_sound_get_audio_group(sound));
	var _group_bank = MUX_GROUPS[$ _group_key];
	
	var _group_idx = ds_list_find_index(_group_bank, sound);
	var _all_idx = ds_list_find_index(_all_bank, sound);
	
	if typeof(sound) == "ref" {
		__mux_sound_fade_out_index(AUDIO_STARTUP_TIME, sound, _group_bank, _all_bank);
	} else {
		audio_sound_gain(sound, 0, time);
		ds_list_delete(_group_bank, _group_idx);
		ds_list_delete(_all_bank,   _all_idx);
		ds_list_add(MUX_P_STOP, sound);
	}
}

/**
 * @desc Crossfades in and out the respective sound instances. If you want to avoit throttling issues, try changing the frame delay to something higher (default=1)
 * @param {Id.Sound|Undefined} _out
 * @param {Id.Sound} _in
 * @param {Real} _time
 * @param {Real} [_delay]=1 delay (in frames) to wait before concluding the transition
 */
function __mux_sound_crossfade_delayed(_out, _in, _time, _delay = 1) {
	if MUX_SHOW_LOG_INFO {
		if is_undefined(_out)
			show_debug_message($"\{ _in: {_in} ({audio_get_name(_in)}), _out: any, _time: {_time}ms \}");
		else 
			show_debug_message($"\{ _in: {_in} ({audio_get_name(_in)}), _out: {_out} ({audio_get_name(_out)}), _time: {_time}ms \}");
	}
	
	audio_sound_gain(_in, 0.5, 0);
	MUX_HANDLER.timer_crossfade[MUX_HANDLER.timer_crossfade_n++] = _delay;
	ds_queue_enqueue(MUX_P_FADE, { in: _in, out: _out, time: _time });
}

/**
 * @param {Real} time
 * @param {Id.DsList} all_bank
 */
function __mux_sound_fade_out_all(time, all_bank) {
	var _start = ds_list_size(all_bank) - 1;
	var _found, _found_idx, _i;
	
	for(_i = _start; _i >= 0; _i--) {
		_found = all_bank[| _i];
		audio_sound_gain(_found.inst, 0, time);
		ds_list_delete(all_bank, _i);
		ds_list_add(MUX_P_STOP, _found.inst);
	}
	
	ds_list_clear(MUX_GROUPS.BGM);
	ds_list_clear(MUX_GROUPS.SFX);
}

/**
 * Crossfades out all registered sounds within the specified group bank
 * @param {Real} time
 * @param {Id.DsList} group_bank
 * @param {Id.DsList} all_bank
 */
function __mux_sound_fade_out_group(time, group_bank, all_bank) {
	var _start = ds_list_size(all_bank) - 1;
	var _found, _found_idx, _i;
	
	for(_i = _start; _i >= 0; _i--) {
		_found = all_bank[| _i];
		_found_idx = ds_list_find_index(group_bank, _found);
		audio_sound_gain(_found.inst, 0, time);
		ds_list_delete(group_bank, _found_idx);
		ds_list_delete(all_bank, _i);
		ds_list_add(MUX_P_STOP, _found.inst);
	}
}

/**
 * Crossfades out all registered sounds whose source is the specified index
 * @param {Real} time
 * @param {Asset.GMSound} index
 * @param {Id.DsList} group_bank
 * @param {Id.DsList} all_bank
 */
function __mux_sound_fade_out_index(time, index, group_bank, all_bank) {
	var _start = ds_list_size(all_bank) - 1;
	var _found, _found_idx, _i;
	
	for(_i = _start; _i >= 0; _i--) {
		_found = all_bank[| _i];
		if _found.index != index then continue;
		_found_idx = ds_list_find_index(group_bank, _found);
		audio_sound_gain(_found.inst, 0, time);
		ds_list_delete(group_bank, _found_idx);
		ds_list_delete(all_bank, _i);
		ds_list_add(MUX_P_STOP, _found.inst);
	}
}
