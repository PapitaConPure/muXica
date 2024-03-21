/// @description Insert description here
if touched {
	var _reduced_influence_zone = sprite_width * image_xscale * 0.22;
	var _influence = clamp(point_distance(x, y, mouse_x, mouse_y) / _reduced_influence_zone, 0.2, 1);
	var _current_touch_cursor = point_direction(x, y, mouse_x, mouse_y);
	var _diff = angle_difference(_current_touch_cursor, last_touch_cursor) * _influence;
	_diff = min(_diff, 180 - spread);
	last_touch_cursor = _current_touch_cursor;
	
	edit_angle += _diff;
	angle = clamp(edit_angle, 90 - spread, 90 + spread);
	edit_angle = clamp(edit_angle, 90 - spread * 3, 90 + spread * 3);
	
	var _norm = 90 - angle + spread;
	var _range = spread * 2;
	var _rate = _norm / _range;
	send = lerp(value_min, value_max, _rate);
}
