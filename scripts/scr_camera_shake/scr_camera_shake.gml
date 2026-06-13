/// Screen Shake & Immersion
///
/// Trauma-based screen shake (Squirrel Eiserloh model) driven by smooth Perlin
/// noise so the picture lurches organically instead of jittering. The game is a
/// fixed-screen sidescroller (no scrolling camera), so the shake is applied by
/// offsetting the whole composited frame: obj_controller owns the state and blits
/// the application surface with an offset in its Post-Draw event.
///
/// Trauma accumulates from any number of sources in a frame and decays over time;
/// shake intensity is trauma^2 so it stays punchy at high energy and fades gently
/// at the tail. Add shake from anywhere with:  camera_shake(0.5);

/// @desc Add shake energy. Total trauma is clamped to 0..1.
/// @param {real} _amount  Trauma to add (0 = nothing, 1 = violent).
function camera_add_trauma(_amount) {
	with (obj_controller) {
		trauma = clamp(trauma + _amount, 0, 1);
	}
}

/// @desc Convenience alias for camera_add_trauma.
function camera_shake(_amount) {
	camera_add_trauma(_amount);
}

/// @desc Advance the shake one frame and refresh shake_x / shake_y / shake_angle.
///       MUST run in obj_controller scope (called from its Step event).
function camera_shake_step() {
	trauma = max(0, trauma - trauma_decay / game_get_speed(gamespeed_fps));

	var _s = trauma * trauma;
	if (_s <= 0) {
		shake_x     = 0;
		shake_y     = 0;
		shake_angle = 0;
		return;
	}

	// Walk along separate slices of the noise field so the three channels are
	// decorrelated. current_time is in ms; the scale sets the shake frequency.
	var _t = current_time * 0.035;
	var _i = global.shake_intensity; // debug-overlay master scale
	shake_x     = max_offset * _s * _i * perlin_noise(_t,    11.3, 0);
	shake_y     = max_offset * _s * _i * perlin_noise(53.9, _t,   0);
	shake_angle = max_angle  * _s * _i * perlin_noise(97.1, 0,   _t);
}
