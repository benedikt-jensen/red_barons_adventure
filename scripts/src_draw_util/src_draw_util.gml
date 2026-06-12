function draw_ammo_column(_x, _def) {
	// Draws one ammo type of the HUD as a column of icons stacking upward
	// from y_base. Once max_rows icons are reached and the count exceeds
	// overflow_min, the column is cut off and an "xN" total is shown instead.
	//
	// _def: { count, sprite, scale, angle, y_base, spacing, icon_step,
	//         max_rows, overflow_min, text_dx }
	var _rows = 0;
	for (var i = 0; i < _def.count; i += _def.icon_step) {
		var _y = _def.y_base - _def.spacing * i;
		_rows += 1;
		if (_rows == _def.max_rows && _def.count > _def.overflow_min) {
			draw_set_valign(fa_bottom);
			draw_set_halign(fa_center);
			draw_set_font(font_ammunition);
			draw_text(_x + _def.text_dx, _y, "x" + string(_def.count));
			draw_set_valign(fa_top);
			draw_set_halign(fa_left);
			break;
		}
		draw_sprite_ext(_def.sprite, 0, _x, _y, _def.scale, _def.scale, _def.angle, c_white, 1);
	}
}

function multiply_colors(color1, color2) {
    var r1 = color_get_red(color1);
    var g1 = color_get_green(color1);
    var b1 = color_get_blue(color1);

    var r2 = color_get_red(color2);
    var g2 = color_get_green(color2);
    var b2 = color_get_blue(color2);

    // Perform component-wise multiplication and normalize
    var new_red = clamp((r1 * r2) / 255, 0, 255);
    var new_green = clamp((g1 * g2) / 255, 0, 255);
    var new_blue = clamp((b1 * b2) / 255, 0, 255);

    // Return the new combined color
    return make_color_rgb(new_red, new_green, new_blue);
}