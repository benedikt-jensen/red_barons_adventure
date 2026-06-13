function instance_create_depth_with_fixture(_parent_id, _x, _y, _depth, _obj_index) {
	var _o = instance_create_depth(_x,_y,_depth,_obj_index);
	_o.parent_id = _parent_id;
	_o.fixture_x = _x - _parent_id.x;
	_o.fixture_y = _y - _parent_id.y;
	return _o;
}

function powerup_types() {
	// Registry of droppable powerups. Add an entry here and it shows up in
	// the weighted roll and the debug overlay automatically.
	return [
		{ key: "bombs",     label: "Bombs",     obj: obj_bombs_powerup },
		{ key: "fire",      label: "Fire Blts", obj: obj_fire_bullets_powerup },
		{ key: "first_aid", label: "First Aid", obj: obj_first_aid },
		{ key: "laser",     label: "Laser",     obj: obj_laser_powerup },
		{ key: "missiles",  label: "Missiles",  obj: obj_missile_powerup },
	];
}

function powerup_effective_weight(_key) {
	var _w = global.powerup_weights[$ _key];
	// A wounded player finds first aid three times as often. The pick is
	// normalized by the total weight, so this shifts the shares without
	// changing the overall drop rate.
	if (_key == "first_aid" && instance_exists(obj_controller) && obj_controller.hp < 50) {
		_w *= 3;
	}
	return _w;
}

function powerup_pick_weighted(_exclude = []) {
	// Weighted random choice; returns the object index, or undefined when
	// every eligible weight is 0.
	var _types = powerup_types();
	var _total = 0;
	for (var i = 0; i < array_length(_types); i++) {
		if (array_contains(_exclude, _types[i].key)) continue;
		_total += powerup_effective_weight(_types[i].key);
	}
	if (_total <= 0) return undefined;

	var _roll = random(_total);
	for (var i = 0; i < array_length(_types); i++) {
		if (array_contains(_exclude, _types[i].key)) continue;
		_roll -= powerup_effective_weight(_types[i].key);
		if (_roll < 0) return _types[i].obj;
	}
	return _types[array_length(_types) - 1].obj; // float-rounding fallback
}

function powerup_drop_chance(_start_chance, _kills_since) {
	// Quadratic ease-in pity ramp:
	//   chance(n) = start + (1 - start) * (n/N)^2
	// Starts at the start chance, climbs slowly at first and ever quicker,
	// and reaches exactly 1 when the dry streak hits N = powerup_max_wait.
	var _t = clamp(_kills_since / max(global.powerup_max_wait, 1), 0, 1);
	return clamp(_start_chance + (1 - _start_chance) * _t * _t, 0, 1);
}

function powerup_effective_chance() {
	// What spawn_powerup_drop's _chance would be for the next regular kill
	// (shown read-only in the debug overlay).
	var _no_powerups_since = global.destroyed_airplanes - global.prev_powerup_at;
	return powerup_drop_chance(global.powerup_start_chance, _no_powerups_since + 1);
}

function spawn_powerup_drop(_x, _y, _rate_scale, _exclude = []) {
	// Saturating ramp (see powerup_drop_chance); resets on a drop.
	// _rate_scale discounts rarer sources (bosses/vehicles).
	// Returns true if one dropped.
	var _no_powerups_since = global.destroyed_airplanes - global.prev_powerup_at;
	var _chance = powerup_drop_chance(global.powerup_start_chance * _rate_scale, _no_powerups_since);
	if (random_range(0, 1) >= _chance) return false;

	var _obj = powerup_pick_weighted(_exclude);
	if (_obj == undefined) return false;
	global.prev_powerup_at = global.destroyed_airplanes;
	instance_create_layer(_x, _y, "Instances", _obj);
	return true;
}

function spawn_powerup_maybe(_x, _y) {
	// Standard drop roll for regular enemies.
	var _dropped = spawn_powerup_drop(_x, _y, 1);
	// During the grasslands boss fight, keep the player stocked with bombs.
	if (!_dropped && irandom(10)==0 && room==room_grasslands && obj_controller.boss_spawned) {
		instance_create_layer(_x, _y, "Instances", obj_bombs_powerup);
	}
}

// --- Environment lanes ----------------------------------------------------

// Lane factors in [ENV_LANE_FREE_MIN, ENV_LANE_FREE_MAX] are reserved for
// planes/tanks (Instances layer) - no env objects spawn there.
#macro ENV_LANE_FREE_MIN 0.5
#macro ENV_LANE_FREE_MAX 0.8

// Pseudo-3D ground reference lines: y of the horizon and y of the lane
// closest to the camera. Speed and scale interpolate between them.
#macro ENV_HORIZON_Y 635
#macro ENV_FRONT_Y   680

function env_speed_from_y(_y) {
	// Shared y -> speed mapping: also used by obj_ground/obj_ground_middle/obj_ground_top
	// to derive their ground_speed, so everything that moves with the environment
	// is tied to the same y coordinate via one formula.
	return 6 * (_y - ENV_HORIZON_Y) / (ENV_FRONT_Y - ENV_HORIZON_Y);
}

function env_scale_from_y(_y) {
	// Same shape as env_speed_from_y(): apparent size falls off linearly with
	// distance from the horizon too, normalized to 1x at the front reference line.
	return (_y - ENV_HORIZON_Y) / (ENV_FRONT_Y - ENV_HORIZON_Y);
}

function env_y_from_factor(_factor) {
	// Inverse of env_scale_from_y(): turns a lane factor back into a y position.
	return ENV_HORIZON_Y + _factor * (ENV_FRONT_Y - ENV_HORIZON_Y);
}

function env_lane_factors(_count = 5, _step = 0.5) {
	// Lanes are evenly spaced in "distance" (1/factor) rather than in factor
	// itself: since far-away y-pixels cover more real distance, back lanes
	// (low factor) end up packed closer together than front lanes - a
	// hyperbolic curve. Factors inside the free zone are skipped.
	var _factors = [];
	var _distance = 1;
	while (array_length(_factors) < _count) {
		var _factor = 1 / _distance;
		if (_factor <= ENV_LANE_FREE_MIN || _factor >= ENV_LANE_FREE_MAX) {
			array_push(_factors, _factor);
		}
		_distance += _step;
	}
	return _factors;
}

function spawn_on_ground(_obj_index, _min_scale = 1, _max_scale = 1) {
	// Lanes come from env_lane_factors(); scroll_speed and scale both derive
	// from the lane's y via env_speed_from_y()/env_scale_from_y(). Scale also
	// gets extra randomization on top, since not every rock/tree/bush at the
	// same distance is the same size.
	static _lane_factors = env_lane_factors();
	var _factor = _lane_factors[irandom(array_length(_lane_factors) - 1)];
	var _y = env_y_from_factor(_factor);
	var _scale_factor = env_scale_from_y(_y);

	var _scale = 0.6 * random_range(_min_scale, _max_scale) * random_range(_scale_factor * 0.75, _scale_factor * 1.25);

	var _inst;
	if (_factor >= ENV_LANE_FREE_MAX) {
		_inst = instance_create_layer(0, 0, "plants_front", _obj_index);
	} else {
		var _depth = layer_get_depth(layer_get_id("plants_back")) + (1 - _factor) * 100;
		_inst = instance_create_depth(0, 0, _depth, _obj_index);
	}
	_inst.scroll_speed = env_speed_from_y(_y);
	_inst.image_xscale = _scale;
	_inst.image_yscale = _scale;
	_inst.x = room_width + _inst.sprite_width / 2;
	_inst.y = _y;
	return _inst;
}

// --- Bosses and enemies ---------------------------------------------------

function spawn_boss_tank() {
	var _inst = instance_create_layer(0, 0, "Instances", obj_boss_tank);
	_inst.distance = 1;
	_inst.x = room_width + _inst.sprite_width / 2;
	_inst.y = 675;
	return _inst;
}

function spawn_boss_ship() {
	var _inst = instance_create_layer(0, 0, "Instances", obj_boss_ship);
	_inst.distance = 1;
	_inst.x = room_width + _inst.sprite_width / 2;
	_inst.y = global.y_limit + 20;
	return _inst;
}

function spawn_vehicle(_obj_index, _min_scale = 1, _max_scale = 1) {
	var _scale = 0.6 * random_range(_min_scale, _max_scale);

	var _inst = instance_create_layer(0, 0, "Instances", _obj_index);
	_inst.distance = 1.5;
	_inst.image_xscale = _scale / _inst.distance;
	_inst.image_yscale = _scale / _inst.distance;
	_inst.x = room_width + _inst.sprite_width / 2;
	_inst.y = 665;
	return _inst;
}

function spawn_at_y_with_speed(_enemy_type, _y, _speed) {
	var _inst = instance_create_layer(0, 0, "Instances", _enemy_type);
	_inst.x = room_width + _inst.sprite_width / 2;
	_inst.y = _y;
	_inst.object_speed = _speed;
	return _inst;
}

function spawn_on_right(_enemy_type) {
	var _inst = instance_create_layer(0, 0, "Instances", _enemy_type);
	_inst.x = room_width + _inst.sprite_width / 2;
	_inst.y = random_range(_inst.sprite_height / 2, room_height - _inst.sprite_height / 2);
	return _inst;
}

function spawn_on_right_limit_y(_enemy_type, _y_min, _y_max) {
	var _inst = instance_create_layer(0, 0, "Instances", _enemy_type);
	_inst.x = room_width + _inst.sprite_width / 2;
	_inst.y = random_range(_y_min + _inst.sprite_height / 2, _y_max - _inst.sprite_height / 2);
	return _inst;
}

function spawn_on_right_limit_y_depth(_enemy_type, _y_min, _y_max, _at_depth) {
	var _inst = instance_create_depth(0, 0, _at_depth, _enemy_type);
	_inst.x = room_width + _inst.sprite_width / 2;
	_inst.y = random_range(_y_min + _inst.sprite_height / 2, _y_max - _inst.sprite_height / 2);
	return _inst;
}

function spawn_bird_flock() {
	// Lone bird, or a flock in one of several formations. All members share
	// one distance band, air current (wave_seed) and base speed, so the
	// whole flock undulates along the same path; per-bird flutter, flap
	// phase and slight speed differences keep it organic.
	// Weighted size variety: loners and pairs are common, mid-size groups
	// the norm, big skeins rare.
	var _roll = random(1);
	var _count;
	if (_roll < 0.22)      _count = 1;
	else if (_roll < 0.42) _count = 2;
	else if (_roll < 0.72) _count = irandom_range(3, 5);
	else if (_roll < 0.92) _count = irandom_range(6, 9);
	else                   _count = irandom_range(10, max(10, round(15 * global.bird_size_mult)));
	// ^ the "Flock Size" debug slider only raises the top end: big flocks
	//   can grow up to 5x (75 birds), small groups stay small

	// A lone hunter flies its own noise path (and may dive)
	if (_count == 1) {
		var _lone = instance_create_layer(0, 0, "Instances", obj_bird);
		_lone.can_dive = true;
		_lone.x = room_width + _lone.sprite_width / 2;
		_lone.y = random_range(room_height * 0.08, room_height * 0.55);
		return;
	}

	// Otherwise a flock with a brain: an invisible obj_flock owns the path
	// and formation, and the members steer toward their slots - so the brain
	// can morph formations or change altitude mid-flight and the birds swoop
	// into place on their own. Big flocks sit in the far bands and pack a
	// little tighter so the formation still fits on screen.
	var _dist = (_count >= 10) ? random_range(2, 3) : random_range(1, 3);

	var _brain = instance_create_depth(0, 0, 0, obj_flock);
	_brain.distance     = _dist;
	_brain.flight_speed = random_range(4.2, 5.5);
	_brain.center_x     = room_width + 150;
	_brain.base_y       = random_range(room_height * 0.08, room_height * 0.55);
	var _pack = (_count >= 10) ? 0.65 : 1; // tighter spacing for big flocks
	_brain.gap_x        = 55 * _pack / _dist;
	_brain.gap_y        = 22 * _pack / _dist;
	_brain.set_formation(choose("v", "line", "cluster"));

	for (var i = 0; i < _count; i++) {
		var _bird = instance_create_layer(0, 0, "Instances", obj_bird);
		// Re-band into the flock's distance (undo the depth offset the
		// Create event applied for its own random distance)
		_bird.depth       -= _bird.distance;
		_bird.distance     = _dist * random_range(0.97, 1.03);
		_bird.depth       += _bird.distance;
		_bird.apply_distance();
		_bird.flight_speed = _brain.flight_speed * random_range(0.98, 1.02);
		_bird.flock_id     = _brain;
		_bird.slot_index   = i;
		// ~1 in 5 birds is a straggler: follows the flock, but loosely
		if (irandom(4) == 0) {
			_bird.cohesion    = 0.45;
			_bird.wander_amp *= 1.6;
		}

		var _slot = _brain.slot_pos(i);
		_bird.x = _slot[0] + random_range(-8, 8);
		_bird.y = _slot[1] + random_range(-6, 6);
		array_push(_brain.members, _bird);
	}
}

// --- Effects ---------------------------------------------------------------

function spawn_explosion(_x, _y) {
	effect_create_above(ef_explosion, _x, _y, 1, c_dkgray);
	part_type_color1(global.ExplosionParticle, $676bae); // darker color: $223364
	part_particles_create(global.part_system, _x, _y, global.ExplosionParticle, 10);

	// Background birds scatter from nearby blasts. The fright spreads
	// outward as a ripple: birds further from the blast flinch later.
	// Explosions happen in the gameplay plane, so birds in far parallax
	// bands don't react at all and mid-band birds only to close blasts.
	with (obj_bird) {
		var _d = point_distance(x, y, _x, _y);
		if (distance < 2 && _d < 380 / distance && startle_delay <= 0) {
			threat_x = _x;
			threat_y = _y;
			startle_delay = max(1, floor(_d / 12));
		}
	}
}

function spawn_explosion_red(_x, _y) {
	effect_create_above(ef_explosion, _x, _y, 1, c_dkgray);
	part_type_color1(global.ExplosionParticle, $0000FF);
	part_particles_create(global.part_system, _x, _y, global.ExplosionParticle, 10);
}

function do_nothing() {}
