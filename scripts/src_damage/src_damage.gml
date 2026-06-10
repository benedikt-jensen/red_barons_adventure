function damage_player(_amount, _cooldown) {
	with (obj_red_baron) {
		if damage_cooldown > 0 { return; }
		damage_cooldown = _cooldown;
		with(obj_controller) {
			if(!variable_instance_exists(id, "__dnd_health")) __dnd_health = 0;
			__dnd_health += real(-_amount * difficulty_multiplier() / other.armour);
		}
	}
}

function difficulty_multiplier() {
	if (global.level_done) {
		return 0;
	}
	var difficulty_multipliers = [0.3, 0.4, 0.5, 0.6, 0.7];
	return difficulty_multipliers[global.difficulty_level];
}

function damage_multiplier() {
	return cheat_is_active("superstrong") ? 10 : 1;
}

function draw_fit_room_size(sprite) {
	draw_sprite_ext(sprite,0,0,0,room_width/sprite_get_width(sprite), room_height/sprite_get_height(sprite),0,c_white,1);
}