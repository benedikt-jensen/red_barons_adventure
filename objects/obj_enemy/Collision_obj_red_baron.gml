damage_player(20, 0);

play_sfx(snd_explosion_3, 0, 0);

global.destroyed_airplanes += 1;

instance_destroy();