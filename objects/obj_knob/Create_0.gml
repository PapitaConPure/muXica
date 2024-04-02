/// @description Insert description here
angle = 90;
edit_angle = angle;
last_touch_angle = 0;
last_touch_cursor = 0;
touched = false;
send = 0;

if sprite_width > 256 {
	sprite_index = spr_knob512_body;
	dot_sprite = spr_knob512_dot;
} else if sprite_width > 128 {
	image_xscale *= 2;
	image_yscale *= 2;
	sprite_index = spr_knob256_body;
	dot_sprite = spr_knob256_dot;
} else {
	image_xscale *= 4;
	image_yscale *= 4;
	sprite_index = spr_knob128_body;
	dot_sprite = spr_knob128_dot;
}
