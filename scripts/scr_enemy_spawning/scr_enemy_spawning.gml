global.spawn_enemy_counter = 0;

function spawn_enemies() {
	if (in_game != 1) return;
	global.enemy_spawn_ramp = min(global.enemy_spawn_ramp + global.enemy_spawn_ramp_rate, global.enemy_spawn_ramp_max);
	global.spawn_enemy_counter += 1;

	while (global.spawn_enemy_counter > 0) {
		global.spawn_enemy_counter -= 1;
		
		spawn_planes();
		spawn_tanks();

	}
}

function spawn_planes() {
	if (random(100) < global.plane_spawn_mult * global.enemy_spawn_ramp / 100) {
		switch (room) {
			case room_sunset:
				if (!boss_spawned) {
					spawn_on_right_limit_y(obj_enemy, 0, global.y_limit);
				}
				break;
			case room_grasslands:
				if (boss_spawned) {
					spawn_on_right_limit_y(obj_enemy, 0, global.y_limit - 200);
				} else {
					spawn_on_right_limit_y(obj_enemy, 0, global.y_limit - 100);
				}
				break;
			case room_mountains:
				if (boss_spawned) {
					if (random(1) < 0.3) {
						spawn_on_right_limit_y(obj_enemy, 0, global.y_limit);
					}
				} else {
					spawn_on_right_limit_y(obj_enemy, 0, global.y_limit);
				}
				break;
			default:
				spawn_on_right_limit_y(obj_enemy, 0, global.y_limit);
				break;
		}
	}
}

function spawn_tanks() {
	switch (room) {
		case room_grasslands:
			if (!boss_spawned) {
				if (random(100) < global.tank_spawn_mult * global.enemy_spawn_ramp / 100) {
					spawn_vehicle(obj_enemy_tank, 1.5, 1.5);
				}
			}
			break;
	}
}