#macro AUDIO_STARTUP_TIME 4

/**
 * @desc 
 * @param {Asset.GMSound} sound_index New sound index
 * @param {Real} priority New sound priority
 * @param {Bool} [loop] New sound loop mode (false by default)
 * @param {Real} [gain] New sound gain (1 by default)
 * @param {Real} [offset] New sound offset (in seconds, defaults to 0)
 * @param {Real} [pitch] New sound pitch (1 by default)
 * @param {Real} [listener_mask] New sound listener bit-mask. Unused on the HTML5 target
 * @returns {Id.Sound}
 */
function mux_sound_play(index, priority, loop = false, gain = 1, offset = 0, pitch = 1, listener_mask = undefined) {
	MUX_CHECK_UNINITIALISED_EX;
	
	var _bank = mux_bank_get_from_sound(index);
	MUX_CHECK_EMITTER_IS_ALL_EX;
	
	var _id = audio_play_sound_on(_bank.default_emitter, index, loop, priority, gain, offset, pitch, listener_mask);
	var _sound = new MuxSound(index, _id);
	_bank.add_sound(_sound);
	MUX_ALL.add_sound(_sound);
	return _id;
}

/**
 * @desc 
 * @param {Id.AudioEmitter} emitter The emitter on which the new sound will play
 * @param {Asset.GMSound} sound_index New sound index
 * @param {Real} priority New sound priority
 * @param {Bool} [loop] New sound loop mode (false by default)
 * @param {Real} [gain] New sound gain (1 by default)
 * @param {Real} [offset] New sound offset (in seconds, defaults to 0)
 * @param {Real} [pitch] New sound pitch (1 by default)
 * @param {Real} [listener_mask] New sound listener bit-mask. Unused on the HTML5 target
 * @returns {Id.Sound}
 */
function mux_sound_play_on(emitter, index, priority, loop = false, gain = 1, offset = 0, pitch = 1, listener_mask = undefined) {
	MUX_CHECK_UNINITIALISED_EX;
	
	var _bank = mux_bank_get(emitter);
	MUX_CHECK_EMITTER_IS_ALL_EX;
	
	var _id = audio_play_sound_on(emitter, index, loop, priority, gain, offset, pitch, listener_mask);
	var _sound = new MuxSound(index, _id);
	_bank.add_sound(_sound);
	MUX_ALL.add_sound(_sound);
	return _id;
}

/**
 * @desc Crossfades from the playing audio to the new audio within the specified time frame.
 *       This function assumes both the FROM sound instance and the TO sound asset are linked to the same muXica sound bank
 * @param {Real} time Time for transition (in seconds)
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
	
	time *= 1000; //Convert to milliseconds because....... yeah
	
	var _all_bank = MUX_ALL;
	var _bank = mux_bank_get_from_sound(to);
	MUX_CHECK_EMITTER_IS_ALL_EX;
	
	if from == all {
		__mux_sound_fade_out_all(time, _all_bank);
		var _id = audio_play_sound_on(_bank.default_emitter, to, loop, priority, 0, offset, pitch, listener_mask);
		__mux_sound_crossfade_delayed(undefined, _id, gain, time);
		var _sound = new MuxSound(to, _id);
		_all_bank.add_sound(_sound);
		return _id;
	}
	
	var _old_all_bank_idx = mux_sound_get_inst_bank_index(_all_bank, from);
	var _id = audio_play_sound_on(_bank.default_emitter, to, loop, priority, 0, offset, pitch, listener_mask);
	__mux_sound_crossfade_delayed(from, _id, gain, time);
	
	var _source_position = audio_sound_get_track_position(from);
	var _relative_position = __mux_wrap(_source_position, 0, audio_sound_length(to), true);
	if synced then audio_sound_set_track_position(_id, _relative_position);
	
	var _old_sound = _all_bank.get_sound(_old_all_bank_idx);
	var _sound = new MuxSound(to, _id);
	_all_bank.replace_sound_at(_old_all_bank_idx, _sound);
	MUX_P_STOP.add_sound(_old_sound);
	return _id;
}

/**
 * @desc Crossfades from the playing audio to the new audio within the specified time frame.
 *       To avoid any weirdness, the emitters of both sounds should be linked to the same bus
 * @param {Id.AudioEmitter} emitter The emitter on which the new sound will play
 * @param {Real} time Time for transition (in seconds)
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
function mux_sound_crossfade_on(emitter, time, from, to, priority, loop = false, synced = false, gain = 1, offset = 0, pitch = 1, listener_mask = undefined) {
	MUX_CHECK_UNINITIALISED_EX;
	
	time *= 1000; //Convert to milliseconds because....... yeah
	
	var _all_bank = MUX_ALL;
	var _bank = mux_bank_get(emitter);
	MUX_CHECK_EMITTER_IS_ALL_EX;
	
	if from == all {
		__mux_sound_fade_out_bank(time, _bank, _all_bank);
		var _id = audio_play_sound_on(emitter, to, loop, priority, 0, offset, pitch, listener_mask);
		__mux_sound_crossfade_delayed(undefined, _id, gain, time);
		var _sound = new MuxSound(to, _id);
		_bank.add_sound(_sound);
		_all_bank.add_sound(_sound);
		return _id;
	}
	
	var _old_bank_idx = mux_sound_get_inst_bank_index(_bank, from);
	var _old_all_bank_idx = mux_sound_get_inst_bank_index(_all_bank, from);
	var _id = audio_play_sound_on(emitter, to, loop, priority, 0, offset, pitch, listener_mask);
	__mux_sound_crossfade_delayed(from, _id, gain, time);
	
	var _source_position = audio_sound_get_track_position(from);
	var _relative_position = __mux_wrap(_source_position, 0, audio_sound_length(to), true);
	if synced then audio_sound_set_track_position(_id, _relative_position);
	
	var _old_sound = _all_bank.get_sound(_old_all_bank_idx);
	var _sound = new MuxSound(to, _id);
	_bank.replace_sound_at(_old_bank_idx, _sound);
	_all_bank.replace_sound_at(_old_all_bank_idx, _sound);
	MUX_P_STOP.add_sound(_old_sound);
	return _id;
}

/**
 * @desc Fades out the supplied sound within the specified time frame
 * @param {Asset.GMSound|Id.Sound|Constant.All} sound Sound instance to stop
 * @param {Real} time Fade out time (in seconds)
 */
function mux_sound_stop(sound, time = 0) {
	MUX_CHECK_UNINITIALISED_EX;
	
	time *= 1000; //Again, convert to milliseconds :) :) :)))))
	
	var _all_bank = MUX_ALL;
	
	if sound == all {
		__mux_sound_fade_out_all(time, _all_bank)
		return;
	}
	
	if not audio_exists(sound) then return;
	
	var _bank = mux_bank_get_from_sound(sound);
	MUX_CHECK_EMITTER_IS_ALL_EX;
	
	if typeof(sound) == "ref" {
		__mux_sound_fade_out_index(time, sound, _bank, _all_bank);
	} else {
		var _bank_idx = _bank.find_index_of(sound);
		var _stopped_sound = _bank.get_sound(_bank_idx);
		var _all_idx = _stopped_sound.get_index_in("all");
		
		audio_sound_gain(sound, 0, time);
		_bank.remove_sound_at(_bank_idx);
		_all_bank.remove_sound_at(_all_idx);
		MUX_P_STOP.add_sound(_stopped_sound);
	}
}

/**
 * @desc Fades out the supplied sound within the specified time frame
 * @param {Id.AudioEmitter} emitter The emitter on which the sound is being played
 * @param {Asset.GMSound|Id.Sound|Constant.All} sound Sound instance to stop
 * @param {Real} time Fade out time (in seconds)
 */
function mux_sound_stop_on(emitter, sound, time = 0) {
	MUX_CHECK_UNINITIALISED_EX;
	
	time *= 1000; //Again, convert to milliseconds :) :) :)))))
	
	var _all_bank = MUX_ALL;
	
	if sound == all {
		__mux_sound_fade_out_all(time, _all_bank)
		return;
	}
	
	if not audio_exists(sound) then return;
	
	var _bank = mux_bank_get(emitter);
	MUX_CHECK_EMITTER_IS_ALL_EX;
	
	if typeof(sound) == "ref" {
		__mux_sound_fade_out_index(time, sound, _bank, _all_bank);
	} else {
		var _bank_idx = _bank.find_index_of(sound);
		var _stopped_sound = _bank.get_sound(_bank_idx);
		var _all_idx = _stopped_sound.get_index_in("all");
		
		audio_sound_gain(sound, 0, time);
		_bank.remove_sound_at(_bank_idx);
		_all_bank.remove_sound_at(_all_idx);
		MUX_P_STOP.add_sound(_stopped_sound);
	}
}

/**
 * @desc Crossfades in and out the respective sound instances. Please keep in mind that the IN sound instance must already have a gain of 0 before this function is called.
 *       If you want to avoit throttling issues, try changing the frame delay to something higher (default is 1, which tends to be fine)
 * @param {Id.Sound|Undefined} out The sound instance that will fade out
 * @param {Id.Sound} in The sound instance that will fade in
 * @param {Real} gain The peak gain the IN sound will reach when the crossfade is concluded
 * @param {Real} time Time in milliseconds to conclude the crossfade
 */
function __mux_sound_crossfade_delayed(out, in, gain, time) {
	MUX_LOG_INFO($"Crossfade [{is_undefined(out) ? "ANY" : $"{audio_get_name(out)}/{out}"}]->[{audio_get_name(in)}/{in}] has been requested and will commence in {time} frames");
	
	//Set up next crossfade event
	var _handler = MUX_HANDLER;
	_handler.timer_crossfade[_handler.timer_crossfade_n++] = MUX_CROSSFADE_DELAY;
	ds_queue_enqueue(MUX_P_FADE, { in, out, gain, time });
}

/**
 * @param {Real} time Time it takes to fade everything out, in milliseconds
 * @param {Struct.MuxBank} all_bank Bank in which all muXica-managed sounds are stored in
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
	
	var _banks = MUX_BANKS;
	var _names = struct_get_names(_banks);
	var _count = array_length(_names);
	var _name, _group;
	_i = 0;
	repeat _count {
		_name = _names[_i++];
		_group = _banks[$ _name];
		_group.flush();
	}
}

/**
 * Crossfades out all registered sounds within the specified group bank
 * @param {Real} time Time it takes to fade out the entire sound's bank, in milliseconds
 * @param {Struct.MuxBank} group_bank The current muXica-managed sound's specific bank
 * @param {Struct.MuxBank} all_bank Bank in which all muXica-managed sounds are stored in
 */
function __mux_sound_fade_out_bank(time, group_bank, all_bank) {
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
 * @param {Real} time Time it takes to fade out the entire umbrella of sounds, in milliseconds
 * @param {Asset.GMSound} index The sound asset index for which all sounds will be faded out
 * @param {Struct.MuxBank} group_bank The current muXica-managed sound's specific bank
 * @param {Struct.MuxBank} all_bank Bank in which all muXica-managed sounds are stored in
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
