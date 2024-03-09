//Use this section to organize your sounds into easy-to-remember categories
//Currently, this only affects mux_sound_is_playing(...) when passing a tag name

mux_tag_create("normal music");
mux_tag_create("boss music");
mux_tag_create("steps sounds");
mux_tag_create("punch sounds");
mux_tag_create("funny sounds");

mux_tag_add("normal music", aud_bgm_test1);
mux_tag_add("punch sounds", aud_sfx_test1);