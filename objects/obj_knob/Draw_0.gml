/// @description Insert description here
var _length = sprite_width * 0.4;
var _x = x + lengthdir_x(_length, angle);
var _y = y + lengthdir_y(_length, angle);

draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
draw_sprite_ext(dot_sprite, 0, _x, _y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
