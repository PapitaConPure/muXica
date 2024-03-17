/// @description Ajusta el volumen a la configuración establecida
function mux_groups_update() {
	struct_foreach(MUX_BANKS, function(_, group) {
		group.set_gain();
	});
}
