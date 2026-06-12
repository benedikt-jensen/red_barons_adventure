/// @description Spawn enemy plane

if (room == room_sunset) {
	frequency = boss_spawned ? 0 : 2;
} else {
	frequency = 1;
}

if(in_game == 1)
{
	if(room == room_grasslands)
	{
		alarm_set(0, random_range(45,100) / frequency);
	
		if(boss_spawned == 1)
		{
			spawn_on_right_limit_y(obj_enemy, 0, global.y_limit-200);
		}
	
		else
		{
			spawn_on_right_limit_y(obj_enemy, 0, global.y_limit-100);
		}
	}

	else
	{
		alarm_set(0, random_range(45,100) / frequency);
	
		spawn_on_right_limit_y(obj_enemy, 0, room==room_sunset&&boss_spawned ? room_height/3 : global.y_limit);
	}
}