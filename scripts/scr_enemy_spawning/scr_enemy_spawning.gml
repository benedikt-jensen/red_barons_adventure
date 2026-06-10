global.spawn_enemy_counter = 0;

function spawn_enemies() {
	if (in_game != 1) return;

	global.enemy_spawn_ramp = min(global.enemy_spawn_ramp + global.enemy_spawn_ramp_rate, global.enemy_spawn_ramp_max);

	global.spawn_enemy_counter += 1;

	while (global.spawn_enemy_counter > 0) {
		global.spawn_enemy_counter -= 1;

		// Sunset spawns planes twice as fast while the boss isn't out yet,
		// and stops spawning them entirely once it is.
		var _plane_freq = (room == room_sunset) ? (boss_spawned ? 0 : 2) : 1;
		if (random(100) < global.plane_spawn_mult * _plane_freq * global.enemy_spawn_ramp / 100) {
			if (room == room_grasslands) {
				spawn_on_right_limit_y(obj_enemy, 0, boss_spawned ? global.y_limit - 200 : global.y_limit - 100);
			} else {
				spawn_on_right_limit_y(obj_enemy, 0, (room == room_sunset && boss_spawned) ? room_height / 3 : global.y_limit);
			}
		}

		if (room == room_grasslands && !boss_spawned) {
			if (random(100) < global.tank_spawn_mult * global.enemy_spawn_ramp / 100) {
				spawn_vehicle(obj_enemy_tank, 1.5, 1.5);
			}
		}
	}
}
