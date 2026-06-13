function damage_player(_amount, _cooldown) {
	with (obj_red_baron) {
		if damage_cooldown > 0 { return; }
		damage_cooldown = _cooldown;
		var _hit = _amount * difficulty_multiplier(); // hit force, before armour
		with(obj_controller) {
			hp += -_hit / other.armour;
		}
		// Shake reflects the hit's force (not the armour-reduced HP loss), so it
		// still jolts under the invincible (high-armour) cheat. Trauma adds
		// linearly so several small hits and one big hit of the same total force
		// shake identically (the running total is clamped to 1 in add_trauma).
		camera_shake(_hit / 30);
	}
}

function difficulty_multiplier() {
	if (global.level_done) {
		return 0;
	}
	var difficulty_multipliers = [0.2, 0.35, 0.5, 0.65, 0.8];
	return difficulty_multipliers[global.difficulty_level];
}

function damage_multiplier() {
	return cheat_is_active("superstrong") ? 10 : 1;
}

function draw_fit_room_size(sprite) {
	draw_sprite_ext(sprite,0,0,0,room_width/sprite_get_width(sprite), room_height/sprite_get_height(sprite),0,c_white,1);
}