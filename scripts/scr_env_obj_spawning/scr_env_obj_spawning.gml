global.spawn_env_obj_counter = 0;

function spawn_env_objects() {
	// Accumulate by scroll speed so ground-object density stays constant
	// regardless of how fast the environment moves.
	global.spawn_env_obj_counter += global.env_speed;

	while (global.spawn_env_obj_counter > 0) {
		global.spawn_env_obj_counter -= 1;

		if (room == room_grasslands) {
			if (random(100) < global.plant_spawn_mult) spawn_on_ground(obj_plant);
			if (random(100) < global.tree_spawn_mult)  spawn_on_ground(obj_tree, 1, 2);
			if (random(100) < global.rock_spawn_mult)  spawn_on_ground(obj_rock, 0.3, 1.3);
		}
	}
}
