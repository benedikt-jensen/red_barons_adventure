global.GUI.update_and_draw();

if (in_game == 1)
{
	var _x_offset = 20 + (global.UsingTouchScreen ? 268 : 0);

	// Health bar (vertical, bottom-left, next to ammunition; empties downward)
	var _hb_w = 30;
	var _hb_h = 170;
	var _hb_x1 = _x_offset;
	var _hb_x2 = _hb_x1 + _hb_w;
	var _hb_y2 = room_height - 10;
	var _hb_y1 = _hb_y2 - _hb_h;
	draw_healthbar(_hb_x1, _hb_y1, _hb_x2, _hb_y2, hp, c_white, c_red, $3FFF00, 3, true, true);

	// Level progress bar (fills up until the boss spawns)
	var _current_level = array_get_index(global.level_order, room);
	if (_current_level != -1 && !boss_spawned) {
		var _gui_w = display_get_gui_width();
		var _bar_w = _gui_w * 0.6;
		var _bar_h = 16;
		var _bar_x1 = (_gui_w - _bar_w) / 2;
		var _bar_y1 = display_get_gui_height() - _bar_h - 15;
		var _progress = clamp(global.level_progress / global.level_progress_max, 0, 1);
		draw_progress_bar(_bar_x1, _bar_y1, _bar_x1 + _bar_w, _bar_y1 + _bar_h, _progress);
	}

	if (global.show_destroyed_airplanes) {
		draw_set_font(font_destroyed_airplanes);
		draw_text(250, 10, "Destroyed Enemies: " + string(global.destroyed_airplanes));
	}

	// Ammunition columns, left to right: missiles, bombs, laser charge
	if (instance_exists(obj_red_baron))
	{
		var _ammo_x = _x_offset + _hb_w + 10;
		draw_ammo_column(_ammo_x + 30, {
			count: obj_red_baron.missiles_powerup, sprite: spr_missile,
			scale: 0.25, angle: 0, y_base: room_height - 20, spacing: 15,
			icon_step: 1, max_rows: 10, overflow_min: 18, text_dx: 0,
		});
		draw_ammo_column(_ammo_x + 75, {
			count: obj_red_baron.bombs_powerup, sprite: spr_bomb,
			scale: 0.2, angle: -45, y_base: room_height - 26, spacing: 30,
			icon_step: 1, max_rows: 4, overflow_min: 8, text_dx: 0,
		});
		draw_ammo_column(_ammo_x + 100, {
			count: obj_red_baron.laser_powerup, sprite: spr_energy_bar_unit,
			scale: 0.6, angle: 0, y_base: room_height - 14, spacing: 8.5,
			icon_step: 2, max_rows: 4, overflow_min: 30, text_dx: 20,
		});
	}
}

fade_in_out();

// Debug overlay (input handling lives in the Step event)
if dbg_overlay {
	var _panel = dbg_panel_layout();
	var _sliders = dbg_slider_defs();
	var _wave_buttons = dbg_wave_button_data();
	var _mx = device_mouse_x_to_gui(0), _my = device_mouse_y_to_gui(0);

	draw_set_alpha(0.8);
	draw_set_color(c_black);
	draw_rectangle(_panel.x1, _panel.y1, _panel.x2, _panel.y2, false);
	draw_set_alpha(1);
	draw_set_color(c_lime);
	draw_rectangle(_panel.x1, _panel.y1, _panel.x2, _panel.y2, true);

	draw_set_font(fnt_debug);
	draw_set_valign(fa_middle);
	draw_set_halign(fa_left);
	draw_set_color(c_lime);
	draw_text(_panel.x1 + 6, _panel.y1 + 18, "DEBUG  [F3 to toggle]");

	for (var i = 0; i < array_length(_sliders); i++) {
		var _slider = _sliders[i];
		var _y  = dbg_slider_y(i, _panel.y1);
		var _v  = _slider.get();
		var _vx = _panel.slider_x1 + (_v / _slider.max) * (_panel.slider_x2 - _panel.slider_x1);

		draw_set_color(c_white);
		draw_set_halign(fa_left);
		draw_text(_panel.x1 + 6, _y, _slider.label);

		draw_set_color(make_color_rgb(60, 60, 60));
		draw_rectangle(_panel.slider_x1, _y - 4, _panel.slider_x2, _y + 4, false);

		draw_set_color(c_lime);
		if _v > 0 draw_rectangle(_panel.slider_x1, _y - 4, _vx, _y + 4, false);
		draw_circle(_vx, _y, 7, false);

		draw_set_color(c_white);
		draw_set_halign(fa_right);
		draw_text(_panel.x2 - 6, _y, string_format(_v, 1, 2));
	}

	draw_set_color(c_white);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_text(_panel.x1 + 6, dbg_wave_header_y(_panel.y1), "Spawn Wave");

	for (var i = 0; i < array_length(_wave_buttons); i++) {
		var _rect = dbg_wave_button_rect(i, _panel.x1, _panel.y1);
		var _hover = (_mx >= _rect[0] && _mx <= _rect[2] && _my >= _rect[1] && _my <= _rect[3]);

		draw_set_color(_hover ? c_lime : make_color_rgb(60, 60, 60));
		draw_rectangle(_rect[0], _rect[1], _rect[2], _rect[3], false);
		draw_set_color(c_lime);
		draw_rectangle(_rect[0], _rect[1], _rect[2], _rect[3], true);

		draw_set_color(_hover ? c_black : c_white);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_text((_rect[0] + _rect[2]) / 2, (_rect[1] + _rect[3]) / 2, _wave_buttons[i].label);
	}

	draw_set_alpha(1);
	draw_set_color(c_white);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(-1);
}
