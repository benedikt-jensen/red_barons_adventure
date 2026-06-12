/// @description Game Over

fade_out(global.fade_out_duration);
exec_delayed(room_goto,[room_game_over],global.fade_out_duration);
//audio_stop(snd_propeller);
game_over = true;
in_game = 0;