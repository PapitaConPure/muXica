/// @description Process sound groups
#macro MUX_SOUND_IS_NO_LONGER_VALID ((not audio_exists(_inst)) or (not audio_is_playing(_inst)))

#macro PROCESS_SELECTED_GROUP \
_size = _group.capacity;\
_empty_count = 0;\
for(_i = _size - 1; _i >= 0; _i--) {\
	if not _group.has_sound(_i) {\
		_empty_count++;\
		continue;\
	}\
	_snd = _group.get_sound(_i);\
	_inst = _snd.inst;\
	if MUX_SOUND_IS_NO_LONGER_VALID {\
		MUX_LOG_STEP($"MuxSound instance [{audio_get_name(_snd.index)}/{_i}] was discarded from a bank because the associated sound is no longer valid");\
		_group.remove_sound_at(_i);\
	}\
}\
if _size > 4 and _empty_count > _size div 2 then _group.shrink_capacity()

var _i, _group, _size, _snd, _inst, _empty_count;

_group = MUX_BGM;
PROCESS_SELECTED_GROUP;

_group = MUX_SFX;
PROCESS_SELECTED_GROUP;

_group = MUX_ALL;
PROCESS_SELECTED_GROUP;

MUX_LOG_STEP("Next Arranger Step");
var _arrangers = MUX_ARRANGERS;
_size = ds_grid_width(_arrangers);
_i = 0;
repeat _size {
	_arrangers[# (_i++), MUX_ARR_F.STRUCT].update();
}

_group = MUX_P_STOP;
_size = _group.capacity;
_empty_count = 0;
for(_i = _size - 1; _i >= 0; _i--) {
	if not _group.has_sound(_i) {
		_empty_count++;
		continue;
	}
	
	_snd = _group.get_sound(_i);
	_inst = _snd.inst;
	
	if MUX_SOUND_IS_NO_LONGER_VALID {
		MUX_LOG_STEP($"MuxSound instance [{audio_get_name(_snd.index)}/{_i}] was unaccounted for deletion as the associated sound no longer exists");
		_group.remove_sound_at(_i);
		_snd.free();
		continue;
	}
	
	if audio_sound_get_gain(_inst) == 0 {
		MUX_LOG_STEP($"Sound stop request {_i} addressed: sound instance {_inst} ({_snd.name}) is fully silent and will be stopped now");
		_group.remove_sound_at(_i);
		_snd.stop();
	}
}
if _size > 4 and _empty_count > _size div 2 then _group.shrink_capacity();

var _val;
_size = array_length(timer_crossfade);
_i = 0;
repeat(_size) {
	_val = timer_crossfade[_i++];
	
	if _val < 0 then continue;
	if _val == 0 then event_user(0);

	timer_crossfade[_i - 1]--;
}
