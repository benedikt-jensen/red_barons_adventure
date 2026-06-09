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