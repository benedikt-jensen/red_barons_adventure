if(hp <= 0)
{
	play_sfx(snd_big_explosion_metal, 0, 0);

	global.destroyed_airplanes += 1;

	instance_destroy();
}

x += - object_speed * global.tank_speed_mult;
y += 0;

if(x < -sprite_width / 2)
{
	instance_destroy();

	script_execute(damage_player, 20, 0);
}