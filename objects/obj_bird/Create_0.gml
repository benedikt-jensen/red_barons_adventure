// Defaults for a lone bird; spawn_bird_flock() overrides these so flock
// mates share a distance band, air current and flight speed.
distance = random_range(1, 3);
depth += distance;

image_xscale = 0.4 / distance;
image_yscale = 0.4 / distance;

// Random flap phase and pace so birds don't flap in sync
image_index = irandom(image_number - 1);
image_speed = random_range(0.7, 1.2);

// Path undulation: sampled by world x (not time), so birds with the same
// wave_seed trace the same path through the air, like a flock riding one
// current.
wave_seed      = random(256);
wave_amplitude = random_range(20, 45);
wave_freq      = 1 / random_range(500, 900); // world px per noise feature
flight_speed   = random_range(4.2, 5.5);
base_y         = undefined; // captured on first Step (spawner sets y after create)
