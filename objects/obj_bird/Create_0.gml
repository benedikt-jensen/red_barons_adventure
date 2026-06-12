// Defaults for a lone bird; spawn_bird_flock() overrides these so flock
// mates share a distance band, air current and flight speed.
distance = random_range(1, 3);
depth += distance;

// Scale, atmospheric haze and sunset tint all follow distance;
// spawn_bird_flock() calls this again after re-banding the bird.
// The dusk silhouette is baked into image_blend here (instead of the
// obj_filter_parent overlay stamp in obj_controller Draw_73) so the bird
// can't cast a fake shadow onto objects its sprite overlaps.
apply_distance = function() {
	image_xscale = 0.4 / distance;
	image_yscale = 0.4 / distance;
	image_alpha  = clamp(1.15 - 0.18 * distance, 0.55, 1);
	// Dark dusk silhouette, lifted toward the sunset sky with distance
	var _haze = clamp((distance - 1) * 0.3, 0, 0.6);
	image_blend = merge_color(
		merge_color(c_white, c_black, 0.8),
		make_color_rgb(255, 190, 160), _haze * 0.5);
};
apply_distance();

// Random flap phase; pace is modulated in Step (flap when climbing, glide
// when descending, wings tucked in a dive)
image_index = irandom(image_number - 1);
flap_pace   = random_range(0.8, 1.2);
image_speed = flap_pace;

// Path = flock center (base_y) + formation slot (form_dy, scaled by the
// flock's shared "breathing") + shared big arc (wave_*) + tiny personal
// flutter (jitter_*). All noise is sampled by world x, so flock mates ride
// the same current.
wave_seed      = random(256);
wave_amplitude = random_range(20, 45);
wave_freq      = 1 / random_range(500, 900); // world px per noise feature
breathe_seed   = random(256);
jitter_seed    = random(256);
jitter_amp     = random_range(2, 5);
form_dy        = 0;
flight_speed   = random_range(4.2, 5.5);
base_y         = undefined; // captured on first Step (spawner sets y after create)
y_prev         = 0;

// Hunting dive (enabled for loners by the spawner)
can_dive = false;
state    = "cruise"; // cruise | dive | recover
dive_vy  = 0;
