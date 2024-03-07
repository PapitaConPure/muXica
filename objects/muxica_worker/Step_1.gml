/// @description Process sound groups
#macro MUX_SOUND_IS_NO_LONGER_VALID ((not audio_exists(_snd)) or (not audio_is_playing(_snd)))
#macro PROCESS_SELECTED_GROUP \
_size = ds_list_size(_group);\
for(_i = _size - 1; _i >= 0; _i--) {\
	_snd = _group[| _i].inst;\
	if MUX_SOUND_IS_NO_LONGER_VALID\
		ds_list_delete(_group, _i);\
}

var _i, _group, _size, _snd;

_group = MUX_GROUPS.BGM;
PROCESS_SELECTED_GROUP

_group = MUX_GROUPS.SFX;
PROCESS_SELECTED_GROUP

_group = MUX_ALL;
PROCESS_SELECTED_GROUP

struct_foreach(mux_arrangers, function(_, arranger) { arranger.update(); });

_group = MUX_P_STOP;
_size = ds_list_size(_group);
for(_i = _size - 1; _i >= 0; _i--) {
	if not audio_exists(_group[| _i]) {
		if MUX_SHOW_LOG_STEP
			show_debug_message($"Se descartó el índice de eliminación {_i} porque el sonido registrado no existe");
		ds_list_delete(_group, _i);
		continue;
	}
	
	_snd = _group[| _i];
	if audio_sound_get_gain(_snd) == 0 {
		if MUX_SHOW_LOG_STEP
			show_debug_message($"Se cumplió la petición de eliminación de índice {_i}: {_snd} ({audio_get_name(_snd)})");
		audio_stop_sound(_snd);
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
