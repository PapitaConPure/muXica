/// @description Ajusta el volumen a la configuración establecida
function audio_groups_update() {
	audio_group_set_gain(BGM, MUX_GROUP_VOLUME_BGM / 100, 0);
	audio_group_set_gain(SFX, MUX_GROUP_VOLUME_SFX / 100, 0);
}
