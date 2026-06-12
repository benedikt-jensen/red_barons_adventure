if(bullet_cooldown == 0)
{
	bullet_cooldown = 10;

	play_sfx(snd_gunshot, 0, 0);

	instance_create_layer(x + 80, y + 0, "Instances", obj_bullet_red_baron);
}