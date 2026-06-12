audio_stop_sound(missile_sound);

play_sfx(snd_missile_explode, 0, 0);

effect_create_below(0, x + 0, y + 0, 0, $FFFFFFFF & $ffffff);