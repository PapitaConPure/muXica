///@desc Sets the track position for the specified sound instance or group
///@param {Asset.GMSound|Id.Sound|String|Constant.All} sound The sound selection to affect
///@param {Real} time The new track position of the selected sounds
function mux_sound_set_track_position(sound, time) {
	static _time = 0;
	_time = time;
	array_foreach(mux_sound_get_array(sound), function(sound) {
		sound.set_track_position(mux_sound_set_track_position._time);
	});
}

///@desc Sets the pitch for the specified sound instance or group
///@param {Asset.GMSound|Id.Sound|String|Constant.All} sound The sound selection to affect
///@param {Real} pitch The new pitch/speed of the selected sounds
function mux_sound_set_pitch(sound, pitch) {
	static _pitch = 0;
	_pitch = pitch;
	array_foreach(mux_sound_get_array(sound), function(sound) {
		sound.set_pitch(mux_sound_set_pitch._pitch);
	});
}

///@desc Pauses the playback of the specified sound instance or group
///@param {Asset.GMSound|Id.Sound|String|Constant.All} sound The sound selection to pause
function mux_sound_pause(sound) {
	array_foreach(mux_sound_get_array(sound), function(sound) { sound.pause(); });
}

///@desc Resumes the playback of the specified sound instance or group
///@param {Asset.GMSound|Id.Sound|String|Constant.All} sound The sound selection to resume
function mux_sound_resume(sound) {
	array_foreach(mux_sound_get_array(sound), function(sound) { sound.resume(); });
}
