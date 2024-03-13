///@desc Sets the track position for the specified sound instance or group
///@param {Asset.GMSound|Id.Sound|Constant.All} sound
///@param {Real} time
function mux_sound_set_track_position(sound, time) {
	static _time = 0;
	_time = time;
	array_foreach(mux_sound_get_array(sound), function(sound) {
		sound.set_track_position(mux_sound_set_track_position._time);
	});
}

///@desc Sets the track position for the specified sound instance or group
///@param {Asset.GMSound|Id.Sound|Constant.All} sound
///@param {Real} pitch
function mux_sound_set_pitch(sound, pitch) {
	static _pitch = 0;
	_pitch = time;
	array_foreach(mux_sound_get_array(sound), function(sound) {
		sound.set_pitch(mux_sound_set_pitch._pitch);
	});
}

///@desc Sets the track position for the specified sound instance or group
///@param {Asset.GMSound|Id.Sound|Constant.All} sound
function mux_sound_pause(sound) {
	array_foreach(mux_sound_get_array(sound), function(sound) { sound.pause(); });
}

///@desc Sets the track position for the specified sound instance or group
///@param {Asset.GMSound|Id.Sound|Constant.All} sound
function mux_sound_resume(sound) {
	array_foreach(mux_sound_get_array(sound), function(sound) { sound.resume(); });
}
