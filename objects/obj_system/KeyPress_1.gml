/// @description Insert description here
switch(keyboard_key) {
	//Repetitive? Yeah idc
	case vk_numpad0: if mux_bank_get("BGM").has_sound(0) then mux_sound_stop(mux_bank_get("BGM").get_sound(0).inst, 0.4); break;
	case vk_numpad1: if mux_bank_get("BGM").has_sound(1) then mux_sound_stop(mux_bank_get("BGM").get_sound(1).inst, 0.4); break;
	case vk_numpad2: if mux_bank_get("BGM").has_sound(2) then mux_sound_stop(mux_bank_get("BGM").get_sound(2).inst, 0.4); break;
	case vk_numpad3: if mux_bank_get("BGM").has_sound(3) then mux_sound_stop(mux_bank_get("BGM").get_sound(3).inst, 0.4); break;
	case vk_numpad4: if mux_bank_get("BGM").has_sound(4) then mux_sound_stop(mux_bank_get("BGM").get_sound(4).inst, 0.4); break;
	case vk_numpad5: if mux_bank_get("BGM").has_sound(5) then mux_sound_stop(mux_bank_get("BGM").get_sound(5).inst, 0.4); break;
	case vk_numpad6: if mux_bank_get("BGM").has_sound(6) then mux_sound_stop(mux_bank_get("BGM").get_sound(6).inst, 0.4); break;
	case vk_numpad7: if mux_bank_get("BGM").has_sound(7) then mux_sound_stop(mux_bank_get("BGM").get_sound(7).inst, 0.4); break;
	case vk_numpad8: if mux_bank_get("BGM").has_sound(8) then mux_sound_stop(mux_bank_get("BGM").get_sound(8).inst, 0.4); break;
	case vk_numpad9: if mux_bank_get("BGM").has_sound(9) then mux_sound_stop(mux_bank_get("BGM").get_sound(9).inst, 0.4); break;
}
