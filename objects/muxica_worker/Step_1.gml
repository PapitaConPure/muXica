/// @description Process sound groups
#macro MUX_SOUND_IS_NO_LONGER_VALID ((not audio_exists(_snd)) or (not audio_is_playing(_snd)))
#macro PROCESS_SELECTED_GROUP \
_size = ds_list_size(_group);\
for(_i = _size - 1; _i >= 0; _i--) {\
	_snd = _group[| _i].inst;\
	if MUX_SOUND_IS_NO_LONGER_VALID {\
		MUX_LOG_STEP($"MuxSound instance [{audio_get_name(_group[| _i].index)}/{_i}] was discarded from a bank because the associated sound is no longer valid");\
		ds_list_delete(_group, _i);\
	}\
}

var _i, _group, _size, _snd;

_group = MUX_GROUPS.BGM;
PROCESS_SELECTED_GROUP

_group = MUX_GROUPS.SFX;
PROCESS_SELECTED_GROUP

_group = MUX_ALL;
PROCESS_SELECTED_GROUP

MUX_LOG_STEP("Next Arranger Step");
struct_foreach(MUX_ARRANGERS, mux_arranger_update_all);

_group = MUX_P_STOP;
_size = ds_list_size(_group);
for(_i = _size - 1; _i >= 0; _i--) {
	if not audio_exists(_group[| _i].inst) {
		MUX_LOG_STEP($"MuxSound instance [{audio_get_name(_group[| _i].index)}/{_i}] was unaccounted for deletion as the associated sound no longer exists");
		ds_list_delete(_group, _i);
		continue;
	}
	
	_snd = _group[| _i];
	if audio_sound_get_gain(_snd.inst) == 0 {
		MUX_LOG_STEP($"Sound stop request {_i} addressed: sound instance {_snd.inst} ({_snd.name}) will be stopped now");
		_snd.stop();
		ds_list_delete(_group, _i);
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
