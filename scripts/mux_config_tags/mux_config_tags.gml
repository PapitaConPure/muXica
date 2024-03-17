//Use this section to organize your sounds into easy-to-remember categories
//Currently, this affects things like mux_sound_any_is_playing(...) and some other mux_sound_... functions when passing a tag name

function mux_config_tags() {
	mux_tag_create("normal music");
	mux_tag_create("boss music");
	mux_tag_create("steps sounds");
	mux_tag_create("punch sounds");
	mux_tag_create("funny sounds");

	mux_tag_add("normal music", aud_bgm_test1);
	mux_tag_add("normal music", aud_bgm_test2);
	mux_tag_add("normal music", aud_bgm_test3);
	mux_tag_add("normal music", aud_bgm_test4);
	
	mux_tag_add("boss music", aud_bgm_test5);

	mux_tag_add("punch sounds", aud_sfx_test1);
}
