// Debug overlay (toggled with F3, see obj_controller).
//
// obj_controller's Step event handles input and Draw GUI renders the panel;
// both build their geometry from the helpers here, so hit detection and
// rendering can never drift apart. To add a slider or wave button, extend
// dbg_slider_defs() / dbg_wave_button_data() - layout adapts automatically.

function dbg_panel_layout() {
	var _gw = display_get_gui_width();
	var _x1 = _gw - 550;
	var _y1 = 10;
	var _wave_count = array_length(dbg_wave_button_data());
	var _last_rect = dbg_wave_button_rect(_wave_count - 1, _x1, _y1);
	return {
		x1: _x1, y1: _y1,
		x2: _gw - 10, y2: _last_rect[3] + 8,
		slider_x1: _x1 + 190,
		slider_x2: _gw - 10 - 90,
	};
}

function dbg_slider_defs() {
	// One entry per slider. get/set wrap the tweakable globals so the
	// slider list is the single place that knows which variable it edits.
	return [
		{ label: "Env Speed",   max: 10, get: function() { return global.env_speed;        }, set: function(_v) { global.env_speed        = _v; } },
		{ label: "Trees",       max: 10, get: function() { return global.tree_spawn_mult;  }, set: function(_v) { global.tree_spawn_mult  = _v; } },
		{ label: "Rocks",       max: 10, get: function() { return global.rock_spawn_mult;  }, set: function(_v) { global.rock_spawn_mult  = _v; } },
		{ label: "Grass",       max: 30, get: function() { return global.plant_spawn_mult; }, set: function(_v) { global.plant_spawn_mult = _v; } },
		{ label: "Plane Speed", max: 5,  get: function() { return global.plane_speed_mult; }, set: function(_v) { global.plane_speed_mult = _v; } },
		{ label: "Tank Speed",  max: 5,  get: function() { return global.tank_speed_mult;  }, set: function(_v) { global.tank_speed_mult  = _v; } },
		{ label: "Plane Spawn", max: 10, get: function() { return global.plane_spawn_mult; }, set: function(_v) { global.plane_spawn_mult = _v; } },
		{ label: "Tank Spawn",  max: 10, get: function() { return global.tank_spawn_mult;  }, set: function(_v) { global.tank_spawn_mult  = _v; } },
		{ label: "Spawn Ramp",  max: global.enemy_spawn_ramp_max,
			get: function() { return global.enemy_spawn_ramp; }, set: function(_v) { global.enemy_spawn_ramp = _v; } },
		{ label: "Plane Bob",   max: 10, get: function() { return global.plane_bob_mult;  }, set: function(_v) { global.plane_bob_mult  = _v; } },
		{ label: "Bob Arc Len", max: 300, get: function() { return global.plane_bob_arc; }, set: function(_v) { global.plane_bob_arc   = _v; } },
	];
}

function dbg_slider_y(_index, _py1) {
	return _py1 + 63 + _index * 35;
}

function dbg_wave_button_data() {
	// Options offered as "spawn wave" buttons in the debug overlay.
	return [
		{ label: "V3 Wave",   formation: "V3", duration: 30, padding: 100, mirror: false },
		{ label: "V5 Wave",   formation: "V5", duration: 40, padding: 100, mirror: false },
		{ label: "V9 Wave",   formation: "V9", duration: 60, padding: 100, mirror: false },
		{ label: "V5 Mirror", formation: "V5", duration: 40, padding: 100, mirror: true  },
	];
}

function dbg_wave_header_y(_py1) {
	// The "Spawn Wave" header sits just below the last slider row, so the
	// section moves down automatically when sliders are added.
	return _py1 + 52 + array_length(dbg_slider_defs()) * 35;
}

function dbg_wave_button_rect(_index, _px1, _py1) {
	// 2-column grid below the "Spawn Wave" header. fnt_debug glyphs are
	// 16x32, so buttons must fit a 9-char label (144px) plus padding.
	var _w = 258, _h = 34, _gap = 12;
	var _col = _index mod 2;
	var _row = _index div 2;
	var _x1 = _px1 + 6 + _col * (_w + _gap);
	var _y1 = dbg_wave_header_y(_py1) + 37 + _row * (_h + _gap);
	return [_x1, _y1, _x1 + _w, _y1 + _h];
}
