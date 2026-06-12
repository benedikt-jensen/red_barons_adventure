if(hp <= 0)
{
	play_sfx(snd_big_explosion_metal, 0, 0);

	global.destroyed_airplanes += 1;

	instance_destroy();
}

if(is_entering == 1)
{
	x += - object_speed;
	y += 0;

	if(x < room_width/2)
	{
		is_entering = 0;
	}
}

else
{
	/// @description boss movement AI
	
	x += vel_x;
	
	acc_x = 1 * perlin_noise(current_time/700)
	
	var max_speed_mag = object_speed * 2
	var max_speed = min((max_x - x) / 30, max_speed_mag) 
	var min_speed = max((x - min_x) / 30, -max_speed_mag)
	vel_x += acc_x
	vel_x = max(-min_speed, min(max_speed,vel_x))

	
	
	if (instance_number(obj_drone)<3 && hp < 70) {
		drone_countdown--;
		if (drone_countdown <= 0) {
			drone_countdown = drone_cooldown;
			var drone = instance_create_layer(x,y-100,layer,obj_drone);
			drone.parent_id = id;
		}
	}
}

if(x < -sprite_width / 2)
{
	instance_destroy();

	with(obj_controller) {
		hp += -20;
	}
}