/// @description Process sound banks
#macro MUX_SOUND_IS_NO_LONGER_VALID ((not audio_exists(_inst)) or (not audio_is_playing(_inst)))

var _names = struct_get_names(mux_sounds);
var _count = array_length(_names);
var _n = 0;
var _i, _name, _bank, _size, _snd, _inst, _empty_count;

repeat _count {
	_name = _names[_n++];
	_bank = mux_bank_get(_name);
	
	_size = _bank.capacity;
	_empty_count = 0;
	
	for(_i = _size - 1; _i >= 0; _i--) {
		if not _bank.has_sound(_i) {
			_empty_count++;
			continue;
		}
		
		_snd = _bank.get_sound(_i);
		_inst = _snd.inst;
		
		if MUX_SOUND_IS_NO_LONGER_VALID {
			MUX_LOG_STEP($"MuxSound instance [{audio_get_name(_snd.index)}/{_i}] was discarded from bank \"{_name}\" because the associated sound is no longer valid");
			_bank.remove_sound_at(_i);
		}
	}
	if _size > 2 and _empty_count > _size div 2 then _bank.shrink_capacity()
}

#region Process arrangers
MUX_LOG_STEP("Next Arranger Step");
var _arrangers = MUX_ARRANGERS;
_size = ds_grid_width(_arrangers);
_i = 0;
repeat _size {
	_arrangers[# (_i++), MUX_ARR_F.STRUCT].update();
}
#endregion

#region Process pending stops
_bank = MUX_P_STOP;
_empty_count = 0;
_size = _bank.capacity;
for(_i = _size - 1; _i >= 0; _i--) {
	if not _bank.has_sound(_i) {
		_empty_count++;
		continue;
	}
	
	_snd = _bank.get_sound(_i);
	_inst = _snd.inst;
	
	if MUX_SOUND_IS_NO_LONGER_VALID {
		MUX_LOG_STEP($"MuxSound instance [{audio_get_name(_snd.index)}/{_i}] was unaccounted for deletion as the associated sound no longer exists");
		_bank.remove_sound_at(_i);
		_snd.free();
		continue;
	}
	
	if audio_sound_get_gain(_inst) == 0 {
		MUX_LOG_STEP($"Sound stop request {_i} addressed: sound instance {_inst} ({_snd.name}) is fully silent and will be stopped now");
		_bank.remove_sound_at(_i);
		_snd.stop();
	}
}
if _size > 2 and _empty_count > _size div 2 then _bank.shrink_capacity();
#endregion

#region Tick crossfade timers
var _val;
_size = array_length(timer_crossfade);
_i = 0;
repeat(_size) {
	_val = timer_crossfade[_i++];
	
	if _val < 0 then continue;
	if _val == 0 then event_user(0);

	timer_crossfade[_i - 1]--;
}
#endregion
