x -= ground_speed * global.env_speed;
if (x < -sprite_width) {
	x += sprite_width;
}