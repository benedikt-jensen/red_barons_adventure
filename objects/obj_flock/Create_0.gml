// Invisible flock brain: owns the group's path, pace and formation.
// Member birds steer toward slot_pos(slot_index) each step, so anything the
// brain changes (formation, altitude, speed) becomes a smooth group maneuver.
// Spawned and configured by spawn_bird_flock().

members        = [];
formation      = "v";   // v | line | cluster
line_side      = choose(-1, 1);
distance       = 2;     // parallax band shared with members
flight_speed   = 4.8;
center_x       = room_width + 100;
base_y         = room_height * 0.3;

// Shared air current (sampled by center_x, like the birds' own noise)
wave_seed      = random(256);
wave_amplitude = random_range(20, 45);
wave_freq      = 1 / random_range(500, 900);
breathe_seed   = random(256);

gap_x = 28;
gap_y = 11;

// Cluster formations get stable per-slot offsets, re-rolled on each morph
cluster_off = [];
roll_cluster = function() {
	// 80 slots so the "Flock Size" debug slider (up to 5x -> 75 birds)
	// always finds an offset
	cluster_off = [];
	for (var i = 0; i < 80; i++) {
		array_push(cluster_off, [
			i * gap_x * 0.5 + random_range(-20, 20),
			random_range(-2.5 * gap_y, 2.5 * gap_y)
		]);
	}
};
roll_cluster();

// Formation morphs ease from the old shape to the new one (morph_t 0..1),
// so slot targets glide instead of jumping.
formation_prev   = formation;
line_side_prev   = line_side;
cluster_off_prev = cluster_off;
morph_t          = 1;

set_formation = function(_f) {
	formation_prev   = formation;
	line_side_prev   = line_side;
	cluster_off_prev = cluster_off;
	morph_t          = 0;
	formation = _f;
	if (_f == "cluster") roll_cluster();
	if (_f == "line") line_side = choose(-1, 1);
};

formation_offset = function(_f, _i, _cluster, _side) {
	switch (_f) {
		case "v": // two diagonal lines trailing the leader
			var _slot = (_i + 1) div 2;
			return [_i * gap_x, ((_i mod 2 == 0) ? 1 : -1) * _slot * gap_y];
		case "line": // single diagonal skein
			return [_i * gap_x * 0.9, _side * _i * gap_y * 0.7];
		default: // loose cluster
			return _cluster[_i];
	}
};

slot_pos = function(_i) {
	// Where bird _i should be right now. Formation offsets breathe with a
	// slow shared noise so the group visibly tightens and fans out.
	var _breathe = 0.7 + 0.6 * (perlin_noise(center_x * 0.002, breathe_seed) + 1) / 2;
	var _cy = base_y + perlin_noise(center_x * wave_freq, wave_seed)
		* wave_amplitude * global.bird_wave_mult / distance;
	var _off = formation_offset(formation, _i, cluster_off, line_side);
	if (morph_t < 1) {
		var _old = formation_offset(formation_prev, _i, cluster_off_prev, line_side_prev);
		var _t = morph_t * morph_t * (3 - 2 * morph_t); // smoothstep
		_off = [lerp(_old[0], _off[0], _t), lerp(_old[1], _off[1], _t)];
	}
	return [center_x + _off[0], _cy + _off[1] * _breathe];
};

// Every few seconds the flock changes its mind about something. Altitude
// and pace changes set targets that the Step event eases toward, so the
// slots glide instead of jumping.
target_base_y = base_y;
target_speed  = flight_speed;
decision_timer = irandom_range(240, 600);
make_decision = function() {
	decision_timer = irandom_range(240, 600);
	switch (irandom(2)) {
		case 0: // morph into a different formation
			var _options = [];
			if (formation != "v")       array_push(_options, "v");
			if (formation != "line")    array_push(_options, "line");
			if (formation != "cluster") array_push(_options, "cluster");
			set_formation(_options[irandom(array_length(_options) - 1)]);
			break;
		case 1: // drift to a new altitude band
			target_base_y = clamp(base_y + random_range(-70, 70),
				room_height * 0.06, room_height * 0.6);
			break;
		default: // pick up or ease the pace
			target_speed = clamp(flight_speed * random_range(0.9, 1.12), 3.8, 6);
			break;
	}
};
