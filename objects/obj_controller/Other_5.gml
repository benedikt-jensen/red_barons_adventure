audio_stop_all();

if room==room_main_menu {
	fade_out(0);
}

if (room == room_mountains) {
	alarm[6] = -1;
	alarm[7] = -1;
}

for (var i = 0; i<array_length(ambiente_sounds); i++) {
	audio_sound_gain(ambiente_sounds[i],0,1000);
}

if (surface_exists(filter_surface)) {
	    surface_set_target(filter_surface);
		draw_clear_alpha(c_black, 0);
		surface_reset_target();
}