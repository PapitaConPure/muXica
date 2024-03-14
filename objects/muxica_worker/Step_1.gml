/// @description Process sound groups
#macro MUX_SOUND_IS_NO_LONGER_VALID ((not audio_exists(_inst)) or (not audio_is_playing(_inst)))

#macro PROCESS_SELECTED_GROUP \
_size = _group.capacity;\
for(_i = _size - 1; _i >= 0; _i--) {\
	if not _group.has_sound(_i) then continue;\
	_snd = _group.get_sound(_i);\
	_inst = _snd.inst;\
	if MUX_SOUND_IS_NO_LONGER_VALID {\
		MUX_LOG_STEP($"MuxSound instance [{audio_get_name(_snd.index)}/{_i}] was discarded from a bank because the associated sound is no longer valid");\
		_group.remove_sound_at(_i);\
	}\
}

var _i, _group, _size, _snd, _inst;

_group = MUX_GROUPS.BGM;
PROCESS_SELECTED_GROUP

_group = MUX_GROUPS.SFX;
PROCESS_SELECTED_GROUP

_group = MUX_ALL;
PROCESS_SELECTED_GROUP

MUX_LOG_STEP("Next Arranger Step");
struct_foreach(MUX_ARRANGERS, mux_arranger_update_all);

_group = MUX_P_STOP;
_size = _group.size;
for(_i = _size - 1; _i >= 0; _i--) {
	_snd = _group.get_sound(_i);
	_inst = _snd.inst;
	
	if MUX_SOUND_IS_NO_LONGER_VALID {
		MUX_LOG_STEP($"MuxSound instance [{audio_get_name(_snd.index)}/{_i}] was unaccounted for deletion as the associated sound no longer exists");
		_group.remove_sound_at(_i);
		continue;
	}
	
	if audio_sound_get_gain(_inst) == 0 {
		MUX_LOG_STEP($"Sound stop request {_i} addressed: sound instance {_inst} ({_snd.name}) is fully silent and will be stopped now");
		_snd.stop();
		_group.remove_sound_at(_i);
	}
}

var _val;
_size = array_length(timer_crossfade);
_i = 0;
repeat(_size) {
	_val = timer_crossfade[_i++];
	
	if _val < 0 then continue;
	if _val == 0 then event_user(0);

	timer_crossfade[_i - 1]--;
}
