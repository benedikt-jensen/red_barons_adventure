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
	|| (global.UsingTouchScreen && mouse_check_button(mb_left) && room == room_game_over)
if (_goto_next_room) {
	if(room==room_game_over)
	{
		/// @description restart

		room_goto(room_main_menu);

		game_over = 0;


	__dnd_health = real(100);
	}

	if(room == room_main_menu)
	{
		if(global.GUI.is_enabled())
		{
			play_sfx(snd_main_menu_click, 0, 0);

				sprite_index = spr_start_button;
				image_index = 0;

				alarm_set(1, global.fade_out_duration);

				script_execute(fade_out, global.fade_out_duration);
		}
	}
}

// Debug mode
if keyboard_check_pressed(vk_f3) dbg_overlay = !dbg_overlay;
if dbg_overlay {
    var _gw = display_get_gui_width();
    var _px1 = _gw - 550, _px2 = _gw - 10, _py1 = 10;
    var _sldr_x1 = _px1 + 190, _sldr_x2 = _px2 - 90;
    var _sldr_y = [_py1 + 63, _py1 + 98, _py1 + 133, _py1 + 168, _py1 + 203, _py1 + 238, _py1 + 273, _py1 + 308, _py1 + 343];
    var _mx = device_mouse_x_to_gui(0), _my = device_mouse_y_to_gui(0);

    if mouse_check_button_pressed(mb_left) && debug_slider_dragging == -1 {
        for (var i = 0; i < 9; i++) {
            if _mx >= _sldr_x1 && _mx <= _sldr_x2 && abs(_my - _sldr_y[i]) < 12 {
                debug_slider_dragging = i;
                break;
            }
        }
    }
    if mouse_check_button_released(mb_left) debug_slider_dragging = -1;
    if debug_slider_dragging >= 0 {
        var _t = clamp((_mx - _sldr_x1) / (_sldr_x2 - _sldr_x1), 0, 1);
        switch (debug_slider_dragging) {
            case 0: global.env_speed        = _t * 10; break;
            case 1: global.tree_spawn_mult  = _t * 10; break;
            case 2: global.rock_spawn_mult  = _t * 10; break;
            case 3: global.plant_spawn_mult = _t * 30; break;
            case 4: global.plane_speed_mult = _t * 5;  break;
            case 5: global.tank_speed_mult  = _t * 5;  break;
            case 6: global.plane_spawn_mult = _t * 10; break;
            case 7: global.tank_spawn_mult  = _t * 10; break;
            case 8: global.enemy_spawn_ramp = _t * global.enemy_spawn_ramp_max; break;
        }
    }

    if mouse_check_button_pressed(mb_left) {
        var _wave_buttons = dbg_wave_button_data();
        for (var i = 0; i < array_length(_wave_buttons); i++) {
            var _rect = dbg_wave_button_rect(i, _px1, _py1);
            if _mx >= _rect[0] && _mx <= _rect[2] && _my >= _rect[1] && _my <= _rect[3] {
                var _b = _wave_buttons[i];
                spawn_formation_centered(global.formations[? _b.formation], obj_enemy, _b.duration, _b.padding, _b.mirror);
            }
        }
    }
}
