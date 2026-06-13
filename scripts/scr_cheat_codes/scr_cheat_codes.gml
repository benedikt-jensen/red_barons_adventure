global.cheat_codes = ds_map_create();
global.cheat_codes[? "lotsofguns"] = false;
global.cheat_codes[? "invincible"] = false;
global.cheat_codes[? "superstrong"] = false;
global.cheat_codes[? "nextroom"] = false;
global.cheat_codes[? "spawnboss"] = false;
global.cheat_codes[? "toohot"] = false;
global.cheat_codes[? "tasered"] = false;
global.cheat_codes[? "rocketman"] = false;
global.cheat_codes[? "gimmebombz"] = false;

function cheat() {
	if keyboard_check_pressed(vk_anykey) {
		var keys = ds_map_keys_to_array(global.cheat_codes);
		for (var i = 0; i<array_length(keys); i++) {
			var cur_key = keys[i];
			var code_len = string_length(cur_key);
			var kb_string_len = string_length(keyboard_string);
			if (code_len>kb_string_len) continue;
			var kb_string_tail = string_lower(string_copy(keyboard_string, 
				kb_string_len + 1 - code_len, kb_string_len));
			if (cur_key==kb_string_tail) {
				global.cheat_codes[? cur_key] = !global.cheat_codes[? cur_key];
				keyboard_string = "";
				update_cheats();
			}
		}
	}
}

function update_cheats() {
	// Go to next room
	if (cheat_is_active("nextroom")) {
		global.cheat_codes[? "nextroom"] = false;
		if (room!=room_main_menu && room!=room_game_over && room!=room_victory) {
			room_goto_next();
		} 
	}
	
	// Spawn mini guns
	if (cheat_is_active("lotsofguns")) {
		with(obj_red_baron) {
			if (array_length(mini_guns) == 0) {
				for (var i = 0; i<3; i++) {
					for (var j = -1; j<=1; j+=2) {
						var _gun = new_tank_gun(id,-25+i*20,j*5,1);
						_gun.min_angle = j==-1 ? 35 - (i-1)*20 : 195 + (i-1)*20;
						_gun.max_angle = j==-1 ? 145 - (i-1)*20: 325 + (i-1)*20;
						_gun.image_angle = j==-1 ? 90 - (i-1)*20 : 270 + (i-1)*20;
						_gun.target_id = obj_enemy_parent;
						_gun.next_shot = irandom(60);
						_gun.rotation_speed = 2;
						_gun.shooting_pattern = new ShootingPattern(0,10,1);
						_gun.bullet_type = get_bullet_type(BulletTypes.Friendly);
						_gun.bullet_type.scale = 0.5;
						_gun.bullet_type.damage = 10;
						_gun.sprite_index = spr_enemy_tank_gun;
						_gun.apply_inertia = false;
						_gun.no_aim_when_unreachable = true;
						_gun.shoot_sound_gain = 0.15;
						_gun.length = 40;
						_gun.image_xscale = 0.4;
						_gun.image_yscale = 0.4;
						array_push(mini_guns, _gun);
					}
				}
			}
		}
	} else {
		with(obj_red_baron) {
			if (array_length(mini_guns) > 0) {
				for (var i = 0; i<array_length(mini_guns); i++) {
					instance_destroy(mini_guns[i]);
				}
			}
			array_resize(mini_guns, 0);
		}
	}
	
	// Become (almost) invincible
	if cheat_is_active("invincible") {
		with (obj_red_baron) {
			armour = 100;
		}
	} else {
		with (obj_red_baron) {
			armour = 1;
		}
	}
	
	// Spawn boss
	if cheat_is_active("spawnboss") {
		global.cheat_codes[? "spawnboss"] = false;
		global.spawn_boss = true;
		global.level_progress = global.level_progress_max;
	}
	
	// charge fire bullets
	if cheat_is_active("toohot") {
		global.cheat_codes[? "toohot"] = false;
		with (obj_red_baron) fire_bullets_powerup += 60;
	}
	
	// charge laser
	if cheat_is_active("tasered") {
		global.cheat_codes[? "tasered"] = false;
		with (obj_red_baron) laser_powerup += 10;
	}
	
	// charge missiles
	if cheat_is_active("rocketman") {
		global.cheat_codes[? "rocketman"] = false;
		with (obj_red_baron) missiles_powerup += 8;
	}
	
	// charge bombs
	if cheat_is_active("gimmebombz") {
		global.cheat_codes[? "gimmebombz"] = false;
		with (obj_red_baron) bombs_powerup += 5;
	}
}

function cheat_is_active(name) {
	return global.cheat_codes[? name];
}