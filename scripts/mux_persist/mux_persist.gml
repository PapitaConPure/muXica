//feather ignore GM2017

///@desc Checks muXica's worker object availability every frame
function mux_persist() {
	if MUX_HANDLER == noone {
		instance_create_depth(0, 0, MUX_HANDLER_DEPTH, muxica_worker);
		with MUX_HANDLER event_user(1);
	} else if not instance_exists(MUX_HANDLER) {
		instance_activate_object(muxica_worker);
	}
}
