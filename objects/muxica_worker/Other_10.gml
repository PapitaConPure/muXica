/// @desc Fade In Sounds
var _request;
while not ds_queue_empty(MUX_P_FADE) {
	_request = ds_queue_dequeue(MUX_P_FADE);
	if not is_undefined(_request.out) then audio_sound_gain(_request.out, 0, _request.time);
	audio_sound_gain(_request.in, 1, _request.time); 
	if MUX_SHOW_LOG_INFO
		show_debug_message($"Concluding crossfade from {is_undefined(_request.out) ? "any" : audio_get_name(_request.out)} to {audio_get_name(_request.in)} in {_request.time}ms");
}
