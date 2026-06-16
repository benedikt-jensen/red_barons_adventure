
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

global.tank_spawn_mult  = 1;
global.tank_spawn_cooldown_duration = 30;
global.tank_spawn_cooldown = 0;
global.tank_speed_mult  = 1;

// --- Powerup drops --------------------------------------------------------
// Which powerup drops is a weighted roll over powerup_types(); the weights
// and a master frequency multiplier are tunable live in the debug overlay
// ("POWERUPS" group). A weight of 0 removes that type from the table.

// Drop chance right after a drop ("Start Chance" debug slider) plus a
// quadratic pity ramp: the chance accelerates with every dry kill and is
// guaranteed (1.0) once the streak reaches powerup_max_wait kills
// ("Max Wait" slider). See powerup_drop_chance().
global.powerup_start_chance = 0.03;
global.powerup_max_wait  = 30;
global.powerup_weights = {
	bombs:     1,
	fire:      1,
	first_aid: 1,
	laser:     1,
	missiles:  1,
};

// Enemy spawn ramp - multiplies plane/tank spawn chances. _points is an
// optional piecewise-linear curve over level progress, e.g. a mid-level
// lull: [[0, 40], [0.4, 100], [0.6, 30], [1, 120]]. When empty, the ramp
// rises linearly from _start to _max over the level instead.
global.enemy_spawn_ramp_start  = 70;
global.enemy_spawn_ramp_max    = 100;
global.enemy_spawn_ramp_points = [];

if (room == room_sunset) {
	global.enemy_spawn_ramp_points = [[0,15], [0.4,35], [0.7,60], [0.9,100], [1,5]];
	global.plane_spawn_mult = 8;
} else if (room == room_grasslands) {
	global.powerup_start_chance = 0.06;
	global.powerup_max_wait  = 60;
	global.enemy_spawn_ramp_points = [[0,15], [0.45,50], [0.8,100], [1,25]];
	global.plane_spawn_mult = 4;
} else if (room == room_mountains) {
	global.enemy_spawn_ramp_points = [[0,15], [0.4,35], [0.7,100], [1,15]];
	global.plane_spawn_mult = 6;
}

global.enemy_spawn_ramp       = global.enemy_spawn_ramp_start;
global.enemy_spawn_ramp_rate  = (global.enemy_spawn_ramp_max - global.enemy_spawn_ramp) / global.level_progress_max;

// LEVEL CONFIG VARS end

layer_set_fx("water", _fx_underwater);

boss_spawned = false;
fade_in(global.fade_in_duration);
ambiente_sounds = [];

global.destroyed_airplanes = 0
global.prev_powerup_at = 0
global.level_done = false;
global.input_shoot_laser = false;

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