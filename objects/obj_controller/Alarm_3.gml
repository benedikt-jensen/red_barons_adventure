if(room==room_grasslands)
{
	if(irandom(50) == 0)
	{
		spawn_on_right_limit_y_depth(obj_hot_air_balloon, 0, room_height*0.6, layer_get_depth(layer_get_id("far_away")));
	}
}

/// @description Spawn birds / balloons

if(room==room_sunset)
{
	// A flock (or loner) every ~4s on average, instead of a steady
	// one-bird-per-second drip.
	if (irandom(3) == 0) {
		spawn_bird_flock();
	}
}

alarm_set(3, 60);