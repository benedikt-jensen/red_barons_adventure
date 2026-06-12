if(hp <= 0)
{
	play_sfx(snd_big_explosion_metal, 0, 0);

	global.destroyed_airplanes += 1;

	instance_destroy();
}

if(is_entering == 1)
{
	x += vel_x;
	y += 0;

	if(x < room_width * 3/4)
	{
		is_entering = 0;
	}
}

else
{
	/// @description boss movement AI
	
	x += vel_x;
	
	acc_x = max_speed_mag / 100 * x_dir;
	
	var max_speed = min((max_x - x) / 50, max_speed_mag) 
	var min_speed = max((x - min_x) / 50, -max_speed_mag)
	vel_x += acc_x
	vel_x = max(-min_speed, min(max_speed,vel_x))
}

if(x < -sprite_width / 2)
{
	instance_destroy();

	with(obj_controller) {
		hp += -20;
	}
}