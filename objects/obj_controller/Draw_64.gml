global.GUI.update_and_draw();


if(in_game == 1)
{
	if(!variable_instance_exists(id, "__dnd_health")) __dnd_health = 0;

	var _x_offset = 20 + (global.UsingTouchScreen ? 268 : 0);

	// Health bar (vertical, bottom-left, next to ammunition; empties downward)
	var _hb_w = 30;
	var _hb_h = 170;
	var _hb_x1 = _x_offset;
	var _hb_x2 = _hb_x1 + _hb_w;
	var _hb_y2 = room_height - 10;
	var _hb_y1 = _hb_y2 - _hb_h;
	draw_healthbar(_hb_x1, _hb_y1, _hb_x2, _hb_y2, __dnd_health, $FFFFFFFF, $FF0000FF & $FFFFFF, $FF3FFF00 & $FFFFFF, 3, (($FFFFFFFF>>24) != 0), (($FFFFFFFF>>24) != 0));

	// Level progress bar (fills up until the boss spawns)
	var _current_level = array_get_index(global.level_order, room);
	if (_current_level != -1 && !boss_spawned) {
		var _gui_w = display_get_gui_width();
		var _bar_w = _gui_w * 0.6;
		var _bar_h = 16;
		var _bar_x1 = (_gui_w - _bar_w) / 2;
		var _bar_y1 = display_get_gui_height() - _bar_h - 15;
		var _progress = clamp(global.level_progress / global.level_progress_max, 0, 1);
		draw_progress_bar(_bar_x1, _bar_y1, _bar_x1 + _bar_w, _bar_y1 + _bar_h, _progress)
	}

	if (global.show_destroyed_airplanes) {
		draw_set_font(font_destroyed_airplanes);
		draw_text(250, 10, string("Destroyed Enemies: ") + string(global.destroyed_airplanes));
	}

	var baron_exists = false;
	baron_exists = instance_exists(obj_red_baron);
	if(baron_exists)
	{
		var _ammo_x_offset = _x_offset + _hb_w + 10;
		for(i = 0; i < obj_red_baron.missiles_powerup; i += 1) {
			var _x = _ammo_x_offset + 30;
			var _y = room_height - (20 + 15 * i);
			if (i == 9 && obj_red_baron.missiles_powerup>18) {
				draw_set_valign(fa_bottom)
				draw_set_halign(fa_center)
				draw_set_font(font_ammunition);
				draw_text(_x, _y, "x" + string(obj_red_baron.missiles_powerup));
				draw_set_valign(fa_top)
				draw_set_halign(fa_left)
				break;
			}
			draw_sprite_ext(spr_missile, 0, _x, _y, 0.25, 0.25, 0, $FFFFFF & $ffffff, 1);
		}
	
		for(i = 0; i < obj_red_baron.bombs_powerup; i += 1) {
			var _x = _ammo_x_offset + 75;
			var _y = room_height - (26 + 30 * i);
			if (i == 3 && obj_red_baron.bombs_powerup>8) {
				draw_set_valign(fa_bottom)
				draw_set_halign(fa_center)
				draw_set_font(font_ammunition);
				draw_text(_x, _y, "x" + string(obj_red_baron.bombs_powerup));
				draw_set_valign(fa_top)
				draw_set_halign(fa_left)
				break;
			}
			draw_sprite_ext(spr_bomb, 0, _x, _y, 0.2, 0.2, -45, $FFFFFF & $ffffff, 1);
		}
	
		for(i = 0; i < obj_red_baron.laser_powerup; i += 2) {
			var _x = _ammo_x_offset + 100;
			var _y = room_height - (14 + 8.5 * i);
			if (i == 6 && obj_red_baron.laser_powerup>30) {
				draw_set_valign(fa_bottom)
				draw_set_halign(fa_center)
				draw_set_font(font_ammunition);
				draw_text(_x + 20, _y, "x" + string(obj_red_baron.laser_powerup));
				draw_set_valign(fa_top)
				draw_set_halign(fa_left)
				break;
			}
			draw_sprite_ext(spr_energy_bar_unit, 0, _x, _y, 0.6, 0.6, 0, $FFFFFF & $ffffff, 1);
		}
	}
}

fade_in_out();

// fade in/out

if dbg_overlay {
    var _gw = display_get_gui_width();
    var _px1 = _gw - 550, _px2 = _gw - 10, _py1 = 10, _py2 = _py1 + 435;
    var _sldr_x1 = _px1 + 190, _sldr_x2 = _px2 - 90;
    var _sldr_y  = [_py1 + 63, _py1 + 98, _py1 + 133, _py1 + 168, _py1 + 203, _py1 + 238, _py1 + 273, _py1 + 308, _py1 + 343];
    var _labels  = ["Env Speed", "Trees", "Rocks", "Grass", "Plane Speed", "Tank Speed", "Plane Spawn", "Tank Spawn", "Spawn Ramp"];
    var _values  = [global.env_speed, global.tree_spawn_mult, global.rock_spawn_mult, global.plant_spawn_mult, global.plane_speed_mult, global.tank_speed_mult, global.plane_spawn_mult, global.tank_spawn_mult, global.enemy_spawn_ramp];
    var _maxes   = [10, 10, 10, 30, 5, 5, 10, 10, global.enemy_spawn_ramp_max];
    var _mx = device_mouse_x_to_gui(0), _my = device_mouse_y_to_gui(0);

    draw_set_alpha(0.8);
    draw_set_color(c_black);
    draw_rectangle(_px1, _py1, _px2, _py2, false);
    draw_set_alpha(1);
    draw_set_color(c_lime);
    draw_rectangle(_px1, _py1, _px2, _py2, true);

    draw_set_font(fnt_debug);
    draw_set_valign(fa_middle);
    draw_set_halign(fa_left);
    draw_set_color(c_lime);
    draw_text(_px1 + 6, _py1 + 18, "DEBUG  [F3 to toggle]");

    for (var i = 0; i < 9; i++) {
        var _y  = _sldr_y[i];
        var _v  = _values[i];
        var _m  = _maxes[i];
        var _vx = _sldr_x1 + (_v / _m) * (_sldr_x2 - _sldr_x1);

        draw_set_color(c_white);
        draw_set_halign(fa_left);
        draw_text(_px1 + 6, _y, _labels[i]);

        draw_set_color(make_color_rgb(60, 60, 60));
        draw_rectangle(_sldr_x1, _y - 4, _sldr_x2, _y + 4, false);

        draw_set_color(c_lime);
        if _v > 0 draw_rectangle(_sldr_x1, _y - 4, _vx, _y + 4, false);
        draw_circle(_vx, _y, 7, false);

        draw_set_color(c_white);
        draw_set_halign(fa_right);
        draw_text(_px2 - 6, _y, string_format(_v, 1, 2));
    }

    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(_px1 + 6, _py1 + 367, "Spawn Wave");

    var _wave_buttons = dbg_wave_button_data();
    for (var i = 0; i < array_length(_wave_buttons); i++) {
        var _rect = dbg_wave_button_rect(i, _px1, _py1);
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
