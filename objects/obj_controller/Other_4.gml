/// @description Execute Code

// var _filter_large_blur = fx_create("_filter_large_blur");
// layer_set_fx("water", _fx_underwater);
// fx_set_single_layer(_fx_underwater, true);

var _fx_underwater = fx_create("_filter_underwater");
// blue fx_set_parameter(_fx_underwater,"g_TintCol", [0.7,0.7,1]);
fx_set_parameter(_fx_underwater,"g_TintCol", [1,1,1]);
fx_set_parameter(_fx_underwater,"g_GlintCol", [0,0,0]);
fx_set_parameter(_fx_underwater,"g_Distort1Amount", 25);
//fx_set_parameter(_fx_underwater,"g_Distort2Amount", 2);
fx_set_parameter(_fx_underwater,"g_Distort1Speed",0.1)
//fx_set_parameter(_fx_underwater,"g_Distort2Speed",0.04)
fx_set_parameter(_fx_underwater,"g_ChromaSpreadAmount",0); 
fx_set_single_layer(_fx_underwater, true);

//g_Distort1Speed (Real)
//g_Distort2Speed (Real)
//g_Distort1Scale (Real)
//g_Distort2Scale (Real)
//g_Distort1Amount (Real)
//g_Distort2Amount (Real)

layer_set_fx("water", _fx_underwater);

boss_spawned = false;
fade_in(global.fade_in_duration);
ambiente_sounds = [];

global.destroyed_airplanes = 0
global.prev_powerup_at = 0
global.level_done = false;

alarm[0] = random_range(30,90);

if (in_game) {
	if (!instance_exists(obj_red_baron)) {
		var _ply = instance_create_layer(128, 375, layer_get_id("Instances"),obj_red_baron);
		_ply.image_xscale = 0.1105244;
		_ply.image_yscale = 0.1105244;
	}
}

if (room == room_mountains) {
	alarm[6] = 100;
	
	// storm ambiente
	var snd = audio_play_sound(snd_windy_storm,0,1,0);
	array_push(ambiente_sounds,snd);
	audio_sound_gain(snd,1,1000);
	
	// rain ambiente
	var snd = audio_play_sound(snd_rain_loop,0,1,0);
	array_push(ambiente_sounds,snd);
	audio_sound_gain(snd,1,1000);
}

if (room == room_victory) {
	in_game = 0;
	instance_deactivate_object(obj_red_baron);
	instance_deactivate_object(obj_music_on_off);
}

if(room==room_grasslands)
{
	global.y_limit = room_height*0.85;
}

if(room==room_sunset)
{
	global.y_limit = room_height*0.75;
}

if(room==room_mountains)
{
	global.y_limit = room_height;
}

/// @description play music

bg_music = play_bg_music();

if(room != room_last)
{
	if(!(room == room_victory))
	{
		alarm_set(3, 30);
	
			alarm_set(4, 120);
	
			alarm_set(5, 500);
	}
}