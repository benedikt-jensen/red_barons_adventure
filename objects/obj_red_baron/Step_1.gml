/// @description - Input Handling

if (!global.UsingTouchScreen) {
	if (keyboard_check_pressed(vk_up)) {
		up = true;
	}
	if (keyboard_check_pressed(vk_down)) {
		down = true;
	}
	if (keyboard_check_pressed(vk_left)) {
		left = true;
	}
	if (keyboard_check_pressed(vk_right)) {
		right = true;
	}

	if (keyboard_check_released(vk_up)) {
		up = false;
	}
	if (keyboard_check_released(vk_down)) {
		down = false;
	}
	if (keyboard_check_released(vk_left)) {
		left = false;
	}
	if (keyboard_check_released(vk_right)) {
		right = false;
	}

	x_movement = (left ? -1 : 0) + (right ? 1 : 0);
	y_movement = (up ? -1 : 0) + (down ? 1 : 0);

	if (abs(x_movement) + abs(y_movement) == 2) {
		x_movement /= sqrt(2);
		y_movement /= sqrt(2);
	}

	// Gamepad stick / D-pad takes over when deflected (mirrors the joystick).
	var _pad = active_gamepad();
	if (_pad >= 0) {
		var _mv = gamepad_move_vector(_pad);
		if (_mv.x != 0 || _mv.y != 0) {
			x_movement = _mv.x;
			y_movement = _mv.y;
		}
	}

} else {
	x_movement = obj_joystick.joy_x / obj_joystick.radius;
	y_movement = obj_joystick.joy_y / obj_joystick.radius;
}

// Gamepad action buttons (shoot / missile / bomb / laser / light).
handle_gamepad_actions();

// "Soft Maneuvering" off: snap analog input to full speed in its direction, so
// small stick/joystick deflections fly at full speed (keyboard is already 0/1).
if (!global.soft_maneuvering) {
	var _m = point_distance(0, 0, x_movement, y_movement);
	if (_m > 0) {
		x_movement /= _m;
		y_movement /= _m;
	}
}

x_movement *= red_baron_speed;
y_movement *= red_baron_speed;