
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

// LEVEL CONFIG VARS

// debug overlay variables
global.level_progress = 0;
global.level_progress_max = 3600;

global.tree_spawn_mult  = 1.5;
global.rock_spawn_mult  = 0.5;
global.plant_spawn_mult = 15;

global.plane_spawn_mult = 1;
global.plane_speed_mult = 1.5;

global.tank_spawn_mult  = 0.3;
global.tank_speed_mult  = 1;

// Enemy spawn ramp - multiplies plane/tank spawn chances, rising from
// _start to _max over the level (per-step rate), then holding at _max.
// Resets to _start at the beginning of each level (see Other_4).
global.enemy_spawn_ramp_start = 70;
global.enemy_spawn_ramp_max   = 100;
global.enemy_spawn_ramp       = global.enemy_spawn_ramp_start;

if (room == room_sunset) {
	global.plane_spawn_mult = 1.5;
} else if (room == room_grasslands) {
} else if (room == room_mountains) {
	global.plane_spawn_mult = 2;
}

global.enemy_spawn_ramp_rate  = (global.enemy_spawn_ramp_max - global.enemy_spawn_ramp) / global.level_progress_max;

// LEVEL CONFIG VARS end

layer_set_fx("water", _fx_underwater);

boss_spawned = false;
fade_in(global.fade_in_duration);
ambiente_sounds = [];

global.destroyed_airplanes = 0
global.prev_powerup_at = 0
global.level_done = false;

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