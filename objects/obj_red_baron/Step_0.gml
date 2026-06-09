if (global.input_shoot) {
	if(bullet_cooldown == 0)
	{
		bullet_cooldown = 10;

		play_sfx(snd_gunshot, 0, 0);

		instance_create_layer(x + 80, y + 0, "Instances", obj_bullet_red_baron);
	}
}

if (global.input_launch_missile) {
	global.input_launch_missile = false;
	if(missiles_powerup > 0)
	{
		missiles_powerup += -1;

		missile_id = instance_create_layer(x + 80, y + 0, "Instances", obj_missile);

		with(missile_id) {
			image_xscale = 0.35;
	image_yscale = 0.35;
		}
	}
}

if (global.input_shoot_laser) {
	if (laser_powerup>0 && !audio_is_playing(snd_laser)) {
		audio_play_sound(snd_laser,0,1);
	}
} else {
	audio_stop_sound(snd_laser);
}

if (global.input_drop_bomb) {
	global.input_drop_bomb = false;
	if(bombs_powerup > 0)
	{
		instance_create_layer(x + 0, y + 0, "Instances", obj_bomb);

		bombs_powerup += -1;
	}
}

damage_cooldown = max(0,damage_cooldown-1);

if(bullet_cooldown > 0)
{
	bullet_cooldown += -1;
}

if((y + y_movement) <= global.y_limit - sprite_height / 2)
{
	if((y + y_movement) >= sprite_height /  2)
{
	x += 0;
y += y_movement;
}
}

if((x + x_movement) <= room_width - sprite_width / 2)
{
	if((x + x_movement) >= sprite_width /  2)
{
	x += x_movement;
y += 0;
}
}

if(y_movement > 0)
{
	if(tilt_angle > -10)
{
	tilt_angle += -2;
}
}

if(y_movement < 0)
{
	if(tilt_angle < 10)
{
	tilt_angle += 2;
}
}

if(y_movement == 0)
{
	if(tilt_angle > 0)
{
	tilt_angle += -2;
}

	if(tilt_angle < 0)
{
	tilt_angle += 2;
}
}

image_angle = tilt_angle;

with(obj_controller) {
	if(!variable_instance_exists(id, "__dnd_health")) __dnd_health = 0;
	if(__dnd_health <= 0)
	{
		with(other) instance_destroy();
	}
}