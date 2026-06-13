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

// ----- Gamepad (controller) support -------------------------------------------
//
// Mapping (Xbox layout): Left stick / D-pad = move, RT = shoot (hold),
// B = launch missile, A = drop bomb, X = laser (hold), LB = toggle light,
// A / Start = confirm in menus. Movement mirrors the virtual joystick: the
// stick is analog, so a partial tilt flies slower.

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

	global.input_shoot = gamepad_button_check(_pad, gp_face3);                  // A (3)
	if (gamepad_button_check_pressed(_pad, gp_face4))  global.input_launch_missile = true; // X (3)
	if (gamepad_button_check_pressed(_pad, gp_shoulderlb))  global.input_drop_bomb       = true; // LT
	if (gamepad_button_check_pressed(_pad, gp_shoulderrb))  global.input_shoot_laser     = true; // RT down
	if (gamepad_button_check_released(_pad,gp_shoulderrb)) global.input_shoot_laser     = false; // RT up
	if (gamepad_button_check_pressed(_pad, gp_face1)) {                          //  Y (1): light toggle
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