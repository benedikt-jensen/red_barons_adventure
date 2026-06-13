/// @description

exec_scheduled_actions()

if (lightning_is_hitting) {
	lightning_intensity = min(max(0,lightning_intensity+0.1),1);
} else {
	lightning_intensity = max(0,lightning_intensity-0.03);
}

cheat()

spawn_env_objects()
spawn_enemies()

if (global.spawn_boss and !boss_spawned) {
	global.spawn_boss = false;
	for (var i=0; i<=global.difficulty_level; i++) {
		global.highest_unlocked_boss[i]
			= max(array_get_index(global.level_order, room),
				global.highest_unlocked_boss[i]);
	}
	switch(room)
	{
		case room_mountains:
			instance_create_layer(room_width*2, room_height / 2, "Instances", obj_zeppelin);
			break;

		case room_grasslands:
			spawn_boss_tank();
			break;

		case room_sunset:
			spawn_boss_ship();
			break;
	}
	boss_spawned = true;
} else if (!boss_spawned) {
	var _current_level = array_get_index(global.level_order, room);
	if (_current_level != -1) {
		global.level_progress += 1;
		if (global.level_progress >= global.level_progress_max) {
			global.spawn_boss = true;
		}
	}
}

var _goto_next_room = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)
	|| (global.UsingTouchScreen && mouse_check_button(mb_left) && room == room_game_over);
if (_goto_next_room) {
	if (room == room_game_over) {
		// Restart
		room_goto(room_main_menu);
		game_over = 0;
		hp = 100;
	}

	if (room == room_main_menu && global.GUI.is_enabled()) {
		play_sfx(snd_main_menu_click, 0, 0);
		sprite_index = spr_start_button;
		image_index = 0;
		alarm_set(1, global.fade_out_duration);
		fade_out(global.fade_out_duration);
	}
}

// Debug overlay input (rendering lives in the Draw GUI event)
if keyboard_check_pressed(vk_f3) dbg_overlay = !dbg_overlay;
if dbg_overlay {
    var _panel = dbg_panel_layout();
    var _rows = dbg_overlay_rows().rows;
    var _mx = device_mouse_x_to_gui(0), _my = device_mouse_y_to_gui(0);

    if mouse_check_button_pressed(mb_left) && debug_slider_dragging == undefined {
        for (var i = 0; i < array_length(_rows); i++) {
            var _row = _rows[i];
            var _ry = _panel.y1 + _row.y;
            if (_row.kind == "header") {
                // Click a group header to collapse/expand it
                if (_mx >= _panel.x1 && _mx <= _panel.x2 && abs(_my - _ry) < 14) {
                    dbg_group_toggle(_row.title);
                    break;
                }
            } else if (_row.def[$ "checkbox"] == true) {
                if (_mx >= _panel.x1 && _mx <= _panel.x2 && abs(_my - _ry) < 12) {
                    _row.def.set(!_row.def.get());
                    break;
                }
            } else if (_row.def[$ "readonly"] != true
            && (_row.def[$ "disabled"] == undefined || !_row.def.disabled())
            && _mx >= _panel.slider_x1 && _mx <= _panel.slider_x2 && abs(_my - _ry) < 12) {
                debug_slider_dragging = _row.def;
                break;
            }
        }
    }
    if mouse_check_button_released(mb_left) debug_slider_dragging = undefined;
    if debug_slider_dragging != undefined {
        if (debug_slider_dragging[$ "disabled"] != undefined && debug_slider_dragging.disabled()) {
            debug_slider_dragging = undefined; // slider got disabled mid-drag
        } else {
            var _t = clamp((_mx - _panel.slider_x1) / (_panel.slider_x2 - _panel.slider_x1), 0, 1);
            debug_slider_dragging.set(_t * debug_slider_dragging.max);
        }
    }

    if mouse_check_button_pressed(mb_left) {
        var _wave_buttons = dbg_wave_button_data();
        for (var i = 0; i < array_length(_wave_buttons); i++) {
            var _rect = dbg_wave_button_rect(i, _panel.x1, _panel.y1);
            if _mx >= _rect[0] && _mx <= _rect[2] && _my >= _rect[1] && _my <= _rect[3] {
                var _b = _wave_buttons[i];
                spawn_formation_centered(global.formations[? _b.formation], obj_enemy, _b.duration, _b.padding, _b.mirror);
            }
        }
    }
}
