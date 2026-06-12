if (base_y == undefined) base_y = y;

x += -flight_speed / distance;
y = base_y + perlin_noise(x * wave_freq, wave_seed) * wave_amplitude / distance;

if (x < -sprite_width) {
	instance_destroy();
}
