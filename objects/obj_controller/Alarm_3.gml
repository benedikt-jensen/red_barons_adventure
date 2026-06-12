if(room==room_grasslands)
{
	if(irandom(50) == 0)
	{
		spawn_on_right_limit_y_depth(obj_hot_air_balloon, 0, room_height*0.6, layer_get_depth(layer_get_id("far_away")));
	}
}

if(room==room_sunset)
{
	spawn_on_right_limit_y(obj_bird, 0, room_height*0.6);
}

alarm_set(3, 60);

/// @description Spawn bird