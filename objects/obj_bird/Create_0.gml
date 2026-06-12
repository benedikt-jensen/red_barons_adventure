// Defaults for a lone bird; spawn_bird_flock() overrides these. Flock birds
// additionally get a flock_id + slot_index and steer toward their slot in
// the obj_flock brain instead of flying their own noise path.
distance = random_range(1, 3);
depth += distance;

// Scale and atmospheric haze follow distance; spawn_bird_flock() calls
// this again after re-banding the bird. The dusk silhouette is baked into
// image_blend here (instead of the obj_filter_parent overlay stamp in
// obj_controller Draw_73) so the bird can't cast a fake shadow onto
// objects its sprite overlaps.
apply_distance = function() {
	image_xscale = 0.4 / distance;
	image_yscale = 0.4 / distance;
	image_alpha  = clamp(1.15 - 0.18 * distance, 0.55, 1);
	image_blend  = merge_color(c_white, c_black, 0.8);
};
apply_distance();

// Random flap phase; pace is modulated in Step (flap when climbing, glide
// when descending, wings tucked in a dive, frantic when panicking)
image_index = irandom(image_number - 1);
flap_pace   = random_range(0.8, 1.2);
image_speed = flap_pace;

// Loner path: shared arc (wave_*) + tiny personal flutter (jitter_*),
// sampled by world x. Flock birds only use jitter_* (their arc comes from
// the brain), kettle birds orbit a thermal instead.
wave_seed      = random(256);
wave_amplitude = random_range(20, 45);
wave_freq      = 1 / random_range(500, 900); // world px per noise feature
jitter_seed    = random(256);
jitter_amp     = random_range(2, 5);
flight_speed   = random_range(4.2, 5.5);
base_y         = undefined; // captured on first Step (spawner sets y after create)
y_prev         = 0;
x_prev         = 0;
vel_x          = 0; // current velocity; Step eases it toward each state's desire
vel_y          = 0;

// Flock membership (set by spawn_bird_flock). Each bird lazily wanders
// around its slot rather than locking onto it; "stragglers" follow even
// more loosely.
flock_id   = noone;
slot_index = 0;
wander_amp = random_range(8, 18);
cohesion   = 1;

// mode "path": fly left (loner path or flock slot-steering).
// mode "kettle": soar in circles around a drifting thermal column.
mode        = "path";
orbit_phase = 0;
orbit_r     = 30;
orbit_speed = 1.2;
center_x    = 0;
center_y    = 0;
drift_speed = 2.5;
flap_burst  = 0;

// Path-mode states: cruise | dive | skim | panic | recover
state       = "cruise";
can_dive    = false; // enabled for loners by the spawner
dive_vy     = 0;
skim_timer  = 0;
panic_timer = 0;
panic_total = 1;
evade_dir   = 1;

// Fright ripple: explosions set startle_delay by distance, so panic spreads
// through a flock as a wave instead of every bird flinching the same frame.
startle_delay = 0;
threat_x      = 0;
threat_y      = 0;

startle = function(_sx, _sy) {
	if (state == "dive" || state == "skim" || state == "panic") return;
	if (mode == "kettle") {
		// Scatter: abandon the thermal and flee as a normal path bird
		mode = "path";
		base_y = y;
		image_xscale = abs(image_xscale);
	}
	state = "panic";
	panic_timer = irandom_range(50, 90);
	panic_total = panic_timer;
	evade_dir = (y < _sy) ? -1 : 1;
};
