if (base_y == undefined) {
	base_y = y;
	y_prev = y;
	x_prev = x;
	vel_x = -flight_speed / distance;
	vel_y = 0;
}

// Fright ripple: the scare arrives a beat after the blast, by distance
if (startle_delay > 0) {
	startle_delay -= 1;
	if (startle_delay == 0) startle(threat_x, threat_y);
}

var _spd = flight_speed / distance;
var _in_flock = (flock_id != noone && instance_exists(flock_id));

if (mode == "kettle") {
	// Soar in a flattened circle around a thermal column that drifts left
	// and gently rides the flock's shared air current.
	center_x -= drift_speed / distance;
	orbit_phase += orbit_speed;
	var _cy = center_y + perlin_noise(center_x * wave_freq, wave_seed)
		* wave_amplitude * global.bird_wave_mult * 0.5 / distance;
	x = center_x + lengthdir_x(orbit_r, orbit_phase);
	y = _cy + lengthdir_y(orbit_r * 0.35, orbit_phase);

	// Keep the velocity trace in sync so a panic conversion is seamless
	vel_x = x - x_prev;
	vel_y = y - y_prev;

	// Soaring: long glides with occasional short flap bursts
	if (flap_burst > 0) flap_burst -= 1;
	else if (irandom(160) == 0) flap_burst = irandom_range(15, 30);
} else {
	// Personal flutter rides on top of whatever the bird is steering toward
	var _flutter = perlin_noise(x * 0.02, jitter_seed) * jitter_amp / distance;
	var _surge = 1 + 0.05 * perlin_noise(x * 0.004, jitter_seed);

	// Steering target: flock slot (cruise/recover) or own noise path.
	// Flock birds don't lock onto the slot - they wander lazily around it
	// on personal noise, so each bird keeps an independent feel.
	var _tx = x, _ty;
	if (_in_flock && (state == "cruise" || state == "recover")) {
		var _slot = flock_id.slot_pos(slot_index);
		_tx = _slot[0] + perlin_noise(x * 0.006, jitter_seed + 31) * wander_amp;
		_ty = _slot[1] + perlin_noise(x * 0.005, jitter_seed + 67) * wander_amp
			+ _flutter;
	} else {
		_ty = base_y + perlin_noise(x * wave_freq, wave_seed)
			* wave_amplitude * global.bird_wave_mult / distance + _flutter;
	}

	// Each state wants a velocity; the bird accelerates toward it (_resp =
	// how quickly it can commit), so speed and position stay continuous.
	var _des_vx, _des_vy, _resp;
	switch (state) {
		case "dive": // tip over progressively, wings folding as speed builds
			dive_vy = min(dive_vy + 0.22, 8 / distance);
			_des_vx = -_spd;
			_des_vy = dive_vy;
			_resp = 0.12;
			if (y > min(base_y + 280 / distance, room_height * 0.78)) {
				// Deep dives end in a low skim over the water
				if (y > room_height * 0.7) {
					state = "skim";
					skim_timer = irandom_range(25, 55);
				} else {
					state = "recover";
				}
			}
			break;

		case "skim": // pull out gradually, glide just above the water
			_des_vx = -_spd * _surge;
			_des_vy = perlin_noise(x * 0.05, jitter_seed) * 0.8;
			_resp = 0.12;
			skim_timer -= 1;
			if (skim_timer <= 0) state = "recover";
			break;

		case "panic": // flee in a decaying arc away from the threat
			// Evade strength fades over the panic, so the flight path is a
			// curve that flattens out and blends into the recovery swoop
			// instead of a sharp V.
			var _fade = panic_timer / panic_total;
			_des_vx = -_spd * _surge * (1 + 0.5 * global.bird_panic_mult * _fade);
			var _evade = 2.6 * global.bird_panic_mult * _fade / distance;
			// Flatten the arc as the sky/water bounds approach (no bouncing)
			if (evade_dir > 0) _evade *= clamp((room_height * 0.8 - y) / 80, 0, 1);
			else               _evade *= clamp((y - 20) / 80, 0, 1);
			_des_vy = evade_dir * _evade;
			_resp = 0.13;
			panic_timer -= 1;
			if (panic_timer <= 0) state = "recover";
			break;

		case "recover": // flap hard and swoop back to the slot / cruise line
			_des_vx = -_spd + clamp((_tx - x) * 0.05 * cohesion, -0.65 * _spd, 0.65 * _spd);
			_des_vy = clamp((_ty - y) * 0.06, -(0.8 + 1.6 / distance), 1.2);
			_resp = 0.06;
			if (abs(_ty - y) < 5 && abs(_tx - x) < 30) state = "cruise";
			break;

		default: // cruise: hold pace, correct gently toward the target
			_des_vx = -_spd * _surge
				+ (_in_flock ? clamp((_tx - x) * 0.05 * cohesion, -0.5 * _spd, 0.5 * _spd) : 0);
			_des_vy = clamp((_ty - y) * 0.08 * (0.5 + 0.5 * cohesion),
				-(0.4 + 2.2 / distance), 0.4 + 2.2 / distance);
			_resp = 0.07;

			// Separation with a continuous falloff, so the push fades in
			// instead of switching on at a hard threshold
			if (_in_flock) {
				var _members = flock_id.members;
				for (var k = 0; k < array_length(_members); k++) {
					var _m = _members[k];
					if (_m == id || !instance_exists(_m)) continue;
					var _crowd = abs(_m.x - x) + abs(_m.y - y);
					if (_crowd < 26) {
						_des_vy += ((y >= _m.y) ? 1 : -1) * (1 - _crowd / 26) * 0.9;
					}
				}
			}

			// Foreground birds shy away from the player flying close by
			if (distance < 1.6 && instance_exists(obj_red_baron)
			&& point_distance(x, y, obj_red_baron.x, obj_red_baron.y) < 140) {
				startle(obj_red_baron.x, obj_red_baron.y);
			} else if (can_dive && y < room_height * 0.45 && irandom(900) == 0) {
				state = "dive";
				dive_vy = max(vel_y, 1.5);
			}
			break;
	}

	// "Steer Resp" debug slider scales how quickly birds commit to a new
	// desired velocity (lower = floatier)
	_resp = clamp(_resp * global.bird_resp_mult, 0.01, 0.6);
	vel_x = lerp(vel_x, _des_vx, _resp);
	vel_y = lerp(vel_y, _des_vy, _resp);
	x += vel_x;
	y += vel_y;
}

var _dy = y - y_prev;
var _dx = x - x_prev;
y_prev = y;
x_prev = x;

// Kettle birds face their direction of travel (sprite art faces left)
if (mode == "kettle") {
	image_xscale = ((_dx > 0) ? -1 : 1) * abs(image_xscale);
}

// Wing pace and how hard the bird banks into its flight path, per behavior
var _pace, _bank, _ease = 0.08;
if (mode == "kettle") {
	_pace = ((flap_burst > 0) ? 1.1 : 0.12) * flap_pace;
	_bank = 0.5;
} else switch (state) {
	case "dive":    _pace = 0.03 * flap_pace; _bank = 1;   _ease = 0.1; break;
	case "skim":    _pace = 0.3  * flap_pace; _bank = 0.4; break;
	case "panic":   _pace = 1.8  * flap_pace; _bank = 0.8; break;
	case "recover": _pace = 1.7  * flap_pace; _bank = 1;   break;
	default:        _pace = ((_dy < 0) ? 1.2 : 0.25) * flap_pace; _bank = 0.6; break;
}
image_speed = lerp(image_speed, _pace * global.bird_flap_mult, _ease);

if (abs(_dx) + abs(_dy) > 0.05) {
	var _dir = point_direction(0, 0, _dx, _dy);
	var _angle_target = (image_xscale < 0)
		? angle_difference(_dir, 0) * _bank    // facing right
		: angle_difference(_dir, 180) * _bank; // facing left
	image_angle = lerp(image_angle, _angle_target, 0.1);
}

if (x < -sprite_width) {
	instance_destroy();
}
