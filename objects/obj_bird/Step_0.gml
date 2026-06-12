if (base_y == undefined) {
	base_y = y - form_dy;
	y_prev = y;
}

// Slight surge/lag within the flock
var _surge = 1 + 0.05 * perlin_noise(x * 0.004, jitter_seed);
x += -flight_speed * _surge / distance;

// The cruise path: formation slot breathes with the flock, the whole thing
// rides the shared arc, plus a personal flutter.
var _breathe = 0.7 + 0.6 * (perlin_noise(x * 0.002, breathe_seed) + 1) / 2;
var _wave    = perlin_noise(x * wave_freq, wave_seed) * wave_amplitude / distance;
var _jitter  = perlin_noise(x * 0.02, jitter_seed) * jitter_amp / distance;
var _path_y  = base_y + form_dy * _breathe + _wave + _jitter;

switch (state) {
	case "dive": // wings tucked, accelerating down
		dive_vy = min(dive_vy + 0.35, 9 / distance);
		y += dive_vy;
		if (y > min(base_y + 280 / distance, room_height * 0.78)) {
			state = "recover";
		}
		break;

	case "recover": // flap hard, climb back to the cruise line
		y += clamp(_path_y - y, -(1 + 2.5 / distance), 1);
		if (abs(_path_y - y) < 4) state = "cruise";
		break;

	default: // cruise
		y = _path_y;
		if (can_dive && y < room_height * 0.45 && irandom(900) == 0) {
			state = "dive";
			dive_vy = 1.5;
		}
		break;
}

var _dy = y - y_prev;
y_prev = y;

// Wing pace: flap while climbing, glide on descents, freeze in a dive,
// pump hard during recovery. Eased so transitions read as behavior.
var _pace_target, _bank;
if (state == "dive") {
	_pace_target = 0.03 * flap_pace;
	_bank = 1;
} else if (state == "recover") {
	_pace_target = 1.7 * flap_pace;
	_bank = 1;
} else {
	_pace_target = (_dy < 0) ? 1.2 * flap_pace : 0.25 * flap_pace;
	_bank = 0.6;
}
image_speed = lerp(image_speed, _pace_target, (state == "dive") ? 0.25 : 0.08);

// Bank into the flight path (sprite faces left, hence the 180 offset);
// full commitment in dives, gentle in cruise.
var _vx = flight_speed / distance;
var _angle_target = angle_difference(point_direction(0, 0, -_vx, _dy), 180) * _bank;
image_angle = lerp(image_angle, _angle_target, 0.1);

if (x < -sprite_width) {
	instance_destroy();
}
