play_sfx(snd_first_aid, 0, 0);

with(obj_controller) {
	var lastHealth = hp;

	
	hp = min(100,lastHealth+40);
}

instance_destroy();