global.input_shoot = false;
global.input_launch_missile = false;
global.input_shoot_laser = false;
global.input_drop_bomb = false;

function handle_input() {
	global.input_shoot = keyboard_check(ord("D"));
	global.input_launch_missile = keyboard_check_pressed(ord("A"));
	global.input_shoot_laser = keyboard_check_pressed(ord("S"));
	global.input_drop_bomb = keyboard_check_pressed(vk_space);
}

function show_touch_controls() {
	return room != room_main_menu
		&& room != room_victory
		&& room != room_game_over
		&& global.UsingTouchScreen;
}

// ----- Graphics quality (global.quality: 0 = low, 1 = medium, 2 = high) --------

/// @desc Display name for the current quality setting.
function quality_name() {
	switch (global.quality) {
		case 0:  return "LOW";
		case 2:  return "HIGH";
		default: return "MEDIUM";
	}
}

/// @desc Multiplier on how many birds spawn (lower quality = fewer, for phones).
function quality_bird_factor() {
	switch (global.quality) {
		case 0:  return 0.3;
		case 2:  return 1.0;
		default: return 0.6;
	}
}

// ----- Gamepad (controller) support -------------------------------------------
//
// Mapping (Xbox layout): Left stick / D-pad = move, A = shoot (hold),
// X = launch missile, Y = toggle light, LT = drop bomb, RT = laser (hold),
// A / Start = confirm in menus. Movement mirrors the virtual joystick: the
// stick is analog, so a partial tilt flies slower.
//
// IMPORTANT: button actions use the *standard* SDL face-button positions
// (gp_face1=A, gp_face2=B, gp_face3=X, gp_face4=Y). GameMaker only guarantees
// these positions for pads it recognizes via its built-in SDL controller
// database; an unrecognized pad falls back to raw button indices and the
// physical buttons shift. If a pad maps wrong, it needs an SDL mapping entry
// rather than hard-coded indices here.

#macro GP_DEADZONE 0.12

/// @desc Device index of the first connected gamepad, or -1 if none.
function active_gamepad() {
	var _count = gamepad_get_device_count();
	for (var i = 0; i < _count; i++) {
		if (gamepad_is_connected(i)) return i;
	}
	return -1;
}

/// @desc Left stick + D-pad as a movement vector (each component -1..1), with a
///       radial deadzone and magnitude clamped to 1. Returns {x:0,y:0} at rest.
function gamepad_move_vector(_pad) {
	var _hx = gamepad_axis_value(_pad, gp_axislh);
	var _hy = gamepad_axis_value(_pad, gp_axislv);
	// D-pad adds full-tilt digital input on top of the stick.
	if (gamepad_button_check(_pad, gp_padl)) _hx = -1;
	if (gamepad_button_check(_pad, gp_padr)) _hx =  1;
	if (gamepad_button_check(_pad, gp_padu)) _hy = -1;
	if (gamepad_button_check(_pad, gp_padd)) _hy =  1;

	var _len = point_distance(0, 0, _hx, _hy);
	if (_len < GP_DEADZONE) return { x: 0, y: 0 };

	var _dir = point_direction(0, 0, _hx, _hy);
	// Rescale the post-deadzone range back to 0..1 (so the gentlest push gives the
	// slowest movement, with no jump at the deadzone edge), then square it for fine
	// control at the low end. This is what makes "soft maneuvering" precise; in
	// non-soft mode Step_1 normalizes the magnitude to 1, so the curve is ignored.
	var _t = min(1, (_len - GP_DEADZONE) / (1 - GP_DEADZONE));
	_t = _t * _t;
	return { x: lengthdir_x(_t, _dir), y: lengthdir_y(_t, _dir) };
}

/// @desc Map gamepad buttons onto the global.input_* action flags consumed by
///       obj_red_baron's Step. Call once per frame from the player's Begin Step.
function handle_gamepad_actions() {
	var _pad = active_gamepad();
	if (_pad < 0) return;

	global.input_shoot = gamepad_button_check(_pad, gp_face1);                              // A: shoot (hold)
	if (gamepad_button_check_pressed(_pad, gp_face3))  global.input_launch_missile = true;  // X: launch missile
	if (gamepad_button_check_pressed(_pad, gp_shoulderlb))  global.input_drop_bomb   = true;  // LT: drop bomb
	if (gamepad_button_check_pressed(_pad, gp_shoulderrb))  global.input_shoot_laser  = true;  // RT: laser down
	if (gamepad_button_check_released(_pad, gp_shoulderrb)) global.input_shoot_laser  = false; // RT: laser up
	if (gamepad_button_check_pressed(_pad, gp_face4)) {                                     // Y: light toggle
		with (obj_red_baron) light_is_on = !light_is_on;
	}
}

/// @desc True the frame a "confirm/advance" button is pressed (A or Start).
function gamepad_confirm_pressed() {
	var _pad = active_gamepad();
	if (_pad < 0) return false;
	return gamepad_button_check_pressed(_pad, gp_face1)
		|| gamepad_button_check_pressed(_pad, gp_start);
}