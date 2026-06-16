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
	// The sky has moods: slow noise over wall time makes quiet spells and
	// busy spells instead of a constant average flock rate.
	var _busy = (perlin_noise(current_time / 30000, 7.3) + 1) / 2;
	if (random(1) < lerp(0.08, 0.5, _busy) * global.bird_rate_mult * quality_bird_factor()) {
		spawn_bird_flock();
	}
}

alarm_set(3, 60);