function instance_create_depth_with_fixture(_parent_id, _x, _y, _depth, _obj_index) {
	var _o = instance_create_depth(_x,_y,_depth,_obj_index);
	_o.parent_id = _parent_id;
	_o.fixture_x = _x - _parent_id.x;
	_o.fixture_y = _y - _parent_id.y;
	return _o;
}

function spawn_powerup_maybe(x,y) {
	if (random_range(0,1) < 0.01 * (global.destroyed_airplanes - global.prev_powerup_at)) {
		global.prev_powerup_at = global.destroyed_airplanes;
		spawn_random_powerup(x,y,
		[
			obj_bombs_powerup,
			obj_fire_bullets_powerup,
			obj_first_aid,
			obj_laser_powerup,
			obj_missile_powerup
		]);
	} else {
		if (irandom(10)==0 && room==room_grasslands && obj_controller.boss_spawned) {
			instance_create_layer(x,y,"Instances",obj_bombs_powerup);
		}
	}
}

function spawn_random_powerup(x,y,possible_powerups) {
	var len = array_length(possible_powerups);
	var i = irandom(len-1);
	instance_create_layer(x,y,"Instances",possible_powerups[i]);
}

function env_speed_from_y(_y) {
	// Shared y -> speed mapping: also used by obj_ground/obj_ground_middle/obj_ground_top
	// to derive their ground_speed, so everything that moves with the environment
	// is tied to the same y coordinate via one formula.
	var _horizon_y = 635;
	var _y_front   = 680;
	return 6 * (_y - _horizon_y) / (_y_front - _horizon_y);
}

function spawn_on_ground(obj_index, min_scale = 1, max_scale = 1) {
	// Fixed lanes within the on-ground band (~646-680) - smaller y spawns objects
	// floating above the ground. scroll_speed and scale both derive from y via
	// env_speed_from_y(). Scale also gets extra randomization on top, since not
	// every rock/tree/bush at the same distance is the same size.
	var _lane_ys = [646.25, 652.1, 671, 680];
	var _y = _lane_ys[irandom(array_length(_lane_ys) - 1)];
	var _speed = env_speed_from_y(_y);
	var _factor = _speed / 6;

	var _scale = 0.6 * random_range(min_scale, max_scale) * random_range(_factor * 0.75, _factor * 1.25);

	if (_factor >= 1) {
		obj_id = instance_create_layer(0, 0, "plants_front", obj_index)
	} else if (_factor >= 0.75) {
		// behind the front lane, but still in front of planes/tanks (Instances, depth 300)
		var _depth = layer_get_depth(layer_get_id("plants_front")) + 50;
		obj_id = instance_create_depth(0, 0, _depth, obj_index)
	} else {
		var _depth = layer_get_depth(layer_get_id("plants_back")) + (1 - _factor) * 100;
		obj_id = instance_create_depth(0, 0, _depth, obj_index)
	}
	obj_id.scroll_speed = _speed;
	obj_id.image_xscale = _scale;
	obj_id.image_yscale = _scale;
	obj_id.x = room_width + obj_id.sprite_width / 2;
	obj_id.y = _y;
}

function spawn_boss_tank() {	
	var _distance = 10
	
	obj_id = instance_create_layer(0, 0, "Instances", obj_boss_tank)
	obj_id.distance = _distance / 10;
	obj_id.x = room_width + obj_id.sprite_width / 2;
	obj_id.y = 675;
}

function spawn_boss_ship() {	
	var _distance = 10
	
	obj_id = instance_create_layer(0, 0, "Instances", obj_boss_ship)
	obj_id.distance = _distance / 10;
	obj_id.x = room_width + obj_id.sprite_width / 2;
	obj_id.y = global.y_limit + 20;
}

function spawn_vehicle(obj_index, min_scale = 1, max_scale = 1) {
	var _scale = 0.6 * random_range(min_scale, max_scale);

	obj_id = instance_create_layer(0, 0, "Instances", obj_index)
	obj_id.distance = 1.5;
	obj_id.image_xscale = _scale / obj_id.distance;
	obj_id.image_yscale = _scale / obj_id.distance;
	obj_id.x = room_width + obj_id.sprite_width / 2;
	obj_id.y = 665;
}

function spawn_at_y_with_speed(enemy_type, _y, _speed) {
	show_debug_message("framecount: {0}", current_time);
	obj_id = instance_create_layer(0, 0, "Instances", enemy_type)
	obj_id.x = room_width + obj_id.sprite_width / 2;
	obj_id.y = _y;
	obj_id.object_speed = _speed;
}

function spawn_on_right(enemy_type) {
	obj_id = instance_create_layer(0, 0, "Instances", enemy_type)
	
	obj_id.x = room_width + obj_id.sprite_width / 2;
	obj_id.y = random_range(0 + obj_id.sprite_height / 2, room_height - obj_id.sprite_height / 2 );
	
}

function spawn_on_right_limit_y(enemy_type,y_min,y_max) {
	obj_id = instance_create_layer(0, 0, "Instances", enemy_type)

	obj_id.x = room_width + obj_id.sprite_width / 2;
	obj_id.y = random_range(y_min + obj_id.sprite_height / 2, y_max - obj_id.sprite_height / 2 );
	
}

function spawn_on_right_limit_y_depth(enemy_type,y_min,y_max, at_depth) {
	obj_id = instance_create_depth(0, 0, at_depth, enemy_type)

	obj_id.x = room_width + obj_id.sprite_width / 2;
	obj_id.y = random_range(y_min + obj_id.sprite_height / 2, y_max - obj_id.sprite_height / 2 );
	
}

function spawn_explosion(x, y) {
	effect_create_above(ef_explosion, x, y, 1, c_dkgray);
	part_type_color1(global.ExplosionParticle, $676bae); // darker color: $223364
	part_particles_create(global.part_system, x, y, global.ExplosionParticle, 10);
}

function spawn_explosion_red(x, y) {
	effect_create_above(ef_explosion, x, y, 1, c_dkgray);
	part_type_color1(global.ExplosionParticle, $0000FF);
	part_particles_create(global.part_system, x, y, global.ExplosionParticle, 10);
}

function do_nothing() {}
