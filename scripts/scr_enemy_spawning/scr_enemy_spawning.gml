global.spawn_enemy_counter = 0;

function spawn_ramp_from_progress(_pct) {
	// Step curve over level progress (0..1): each [progress, ramp] point in
	// global.enemy_spawn_ramp_points (sorted; see obj_controller Other_4)
	// sets the ramp for its entire region - the value holds flat until the
	// next point's progress is reached. No interpolation.
	// Returns undefined when no points are set, so spawn_enemies() falls
	// back to the classic linear ramp.
	// Debug overlay "Ignore Pts" checkbox bypasses the curve entirely.
	if (global.dbg_ignore_ramp_points) return undefined;

	var _pts = global.enemy_spawn_ramp_points;
	var _n = array_length(_pts);
	if (_n == 0) return undefined;

	var _value = _pts[0][1];
	for (var i = 1; i < _n; i++) {
		if (_pct < _pts[i][0]) break;
		_value = _pts[i][1];
	}
	return _value;
}

function spawn_enemies() {
	if (in_game != 1) return;

	var _pct = clamp(global.level_progress / global.level_progress_max, 0, 1);
	var _curve_ramp = spawn_ramp_from_progress(_pct);
	if (_curve_ramp != undefined) {
		global.enemy_spawn_ramp = _curve_ramp;
	} else {
		// Fallback: linear climb toward the max
		global.enemy_spawn_ramp = min(global.enemy_spawn_ramp + global.enemy_spawn_ramp_rate, global.enemy_spawn_ramp_max);
	}

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
			case room_grasslands:
				if (boss_spawned) {
					spawn_on_right_limit_y(obj_enemy, 0, global.y_limit - 200);
				} else {
					spawn_on_right_limit_y(obj_enemy, 0, global.y_limit - 100);
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
				if (global.tank_spawn_cooldown <= 0) {
					if (random(100) < global.tank_spawn_mult * global.enemy_spawn_ramp / 100) {
						global.tank_spawn_cooldown = global.tank_spawn_cooldown_duration;
						spawn_vehicle(obj_enemy_tank, 1.5, 1.5);
					}
				} else {
					global.tank_spawn_cooldown -= 1;
				}
			}
			break;
	}
}