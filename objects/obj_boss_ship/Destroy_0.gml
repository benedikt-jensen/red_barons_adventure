// Explosions across the hull
instance_create_layer(x - 180, y, "Instances", obj_explosion);
instance_create_layer(x,       y, "Instances", obj_explosion);
instance_create_layer(x + 180, y, "Instances", obj_explosion);
spawn_explosion(x, y);

fade_out(global.fade_out_duration);
if (laser_sound) {
	audio_stop_sound(laser_sound);
}
level_done();

spawn_powerup_maybe_rare(x, y);
