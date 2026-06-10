/// @description

exec_scheduled_actions()

if (lightning_is_hitting) {
	lightning_intensity = min(max(0,lightning_intensity+0.1),1);
} else {
	lightning_intensity = max(0,lightning_intensity-0.03);
}

cheat()

if (global.spawn_boss and !boss_spawned) {
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
} else {
	var _current_level = array_get_index(global.level_order, room);
	if (_current_level != -1 && global.destroyed_airplanes >= global.target_destroyed_enemies[_current_level]) {
		global.spawn_boss = true;
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
    var _px1 = _gw - 370, _px2 = _gw - 10, _py1 = 10;
    var _sldr_x1 = _px1 + 105, _sldr_x2 = _px2 - 50;
    var _sldr_y = [_py1 + 45, _py1 + 80, _py1 + 115, _py1 + 150];
    var _mx = device_mouse_x_to_gui(0), _my = device_mouse_y_to_gui(0);

    if mouse_check_button_pressed(mb_left) && debug_slider_dragging == -1 {
        for (var i = 0; i < 4; i++) {
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
            case 3: global.plant_spawn_mult = _t * 10; break;
        }
    }
}