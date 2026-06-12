if(bullets_left == 0)
{
	alarm_set(0, 180);

	bullets_left = fast_firing;
}

else
{
	alarm_set(0, 22);

	bullets_left += -1;

	/// @description Shoot
	
	var _x = gun_x + lengthdir_x(140,gun_direction) * image_xscale;
	var _y = gun_y + lengthdir_y(140,gun_direction) * image_yscale;
	var _bullet = instance_create_layer(_x,_y,layer,obj_enemy_bullet);
	play_sfx(snd_tank_gunshot, 0, 0)
	_bullet.direction= gun_direction;
	_bullet.speed = 15;
	_bullet.x_speed = 0//vel_x;
	_bullet.image_angle = gun_direction;
}