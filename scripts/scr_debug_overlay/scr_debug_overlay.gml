// Debug overlay (toggled with F3, see obj_controller).
//
// obj_controller's Step event handles input and Draw GUI renders the panel;
// both build their geometry from the helpers here, so hit detection and
// rendering can never drift apart.
//
// Sliders are organized into collapsible groups - click a group header to
// fold it away. To add a slider, extend its group in dbg_slider_groups();
// the layout (and the wave-button section below) adapts automatically.

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

function dbg_slider_groups() {
	// One entry per group; one entry per slider. get/set wrap the tweakable
	// globals so this list is the single place that knows which variable a
	// slider edits. Many of the multipliers disable their behavior at 0.
	return [
		{ title: "ENVIRONMENT", sliders: [
			{ label: "Env Speed",   max: 10, get: function() { return global.env_speed;        }, set: function(_v) { global.env_speed        = _v; } },
			{ label: "Trees",       max: 10, get: function() { return global.tree_spawn_mult;  }, set: function(_v) { global.tree_spawn_mult  = _v; } },
			{ label: "Rocks",       max: 10, get: function() { return global.rock_spawn_mult;  }, set: function(_v) { global.rock_spawn_mult  = _v; } },
			{ label: "Grass",       max: 30, get: function() { return global.plant_spawn_mult; }, set: function(_v) { global.plant_spawn_mult = _v; } },
		] },
		{ title: "ENEMIES", sliders: [
			{ label: "Plane Speed", max: 5,  get: function() { return global.plane_speed_mult; }, set: function(_v) { global.plane_speed_mult = _v; } },
			{ label: "Tank Speed",  max: 5,  get: function() { return global.tank_speed_mult;  }, set: function(_v) { global.tank_speed_mult  = _v; } },
			{ label: "Plane Spawn", max: 10, get: function() { return global.plane_spawn_mult; }, set: function(_v) { global.plane_spawn_mult = _v; } },
			{ label: "Tank Spawn",  max: 10, get: function() { return global.tank_spawn_mult;  }, set: function(_v) { global.tank_spawn_mult  = _v; } },
			// Always shows the true live ramp; the slider is disabled while
			// "Ignore Pts" is on
			{ label: "Spawn Ramp",  max: global.enemy_spawn_ramp_max,
				disabled: function() { return global.dbg_ignore_ramp_points; },
				get: function() { return global.enemy_spawn_ramp; }, set: function(_v) { global.enemy_spawn_ramp = _v; } },
			// Bypass the per-level enemy_spawn_ramp_points curve
			{ label: "Ignore Pts", checkbox: true,
				get: function() { return global.dbg_ignore_ramp_points; },
				set: function(_v) { global.dbg_ignore_ramp_points = _v; } },
			{ label: "Plane Bob",   max: 10,  get: function() { return global.plane_bob_mult; }, set: function(_v) { global.plane_bob_mult = _v; } },
			{ label: "Bob Arc Len", max: 300, get: function() { return global.plane_bob_arc;  }, set: function(_v) { global.plane_bob_arc  = _v; } },
		] },
		{ title: "CAMERA", sliders: [
			{ label: "Shake Scale", max: 30, get: function() { return global.shake_intensity; }, set: function(_v) { global.shake_intensity = _v; } },
		] },
		{ title: "POWERUPS", sliders: dbg_powerup_sliders() },
		{ title: "BIRDS", sliders: [
			{ label: "Flock Rate",  max: 10, get: function() { return global.bird_rate_mult;     }, set: function(_v) { global.bird_rate_mult     = _v; } },
			{ label: "Wave Amp",    max: 3, get: function() { return global.bird_wave_mult;     }, set: function(_v) { global.bird_wave_mult     = _v; } },
			{ label: "Flap Pace",   max: 3, get: function() { return global.bird_flap_mult;     }, set: function(_v) { global.bird_flap_mult     = _v; } },
			{ label: "Panic",       max: 3, get: function() { return global.bird_panic_mult;    }, set: function(_v) { global.bird_panic_mult    = _v; } },
			{ label: "Steer Resp",  max: 3, get: function() { return global.bird_resp_mult;     }, set: function(_v) { global.bird_resp_mult     = _v; } },
			{ label: "Decisions",   max: 5, get: function() { return global.bird_decision_mult; }, set: function(_v) { global.bird_decision_mult = _v; } },
			{ label: "Flock Size",  max: 5, get: function() { return global.bird_size_mult;     }, set: function(_v) { global.bird_size_mult     = _v; } },
		] },
	];
}

function dbg_powerup_sliders() {
	// Master drop frequency plus one weight slider per entry in the powerup
	// registry (powerup_types in scr_spawn) - new powerups appear here
	// automatically. A weight of 0 removes the powerup from the drop table.
	var _defs = [
		{ label: "Start Chance", max: 1,
			get: function() { return global.powerup_start_chance; },
			set: function(_v) { global.powerup_start_chance = _v; } },
		// Kills until the pity ramp guarantees a drop
		{ label: "Max Wait", max: 100,
			get: function() { return global.powerup_max_wait; },
			set: function(_v) { global.powerup_max_wait = max(1, round(_v)); } },
		// Live view of the ramped chance the next kill will drop a powerup
		{ label: "Effective", readonly: true,
			get: function() { return powerup_effective_chance(); } },
	];
	var _types = powerup_types();
	for (var i = 0; i < array_length(_types); i++) {
		array_push(_defs, {
			label: _types[i].label,
			max: 3,
			get: method({ key: _types[i].key },
				function() { return global.powerup_weights[$ key]; }),
			set: method({ key: _types[i].key },
				function(_v) { global.powerup_weights[$ key] = _v; }),
		});
	}
	return _defs;
}

function dbg_group_state() {
	static _state = {};
	return _state;
}

function dbg_group_expanded(_title) {
	var _s = dbg_group_state();
	if (!variable_struct_exists(_s, _title)) {
		// Only one group starts expanded: with several large groups open at
		// once the panel would grow past the bottom of the screen.
		_s[$ _title] = (_title == "POWERUPS");
	}
	return _s[$ _title];
}

function dbg_group_toggle(_title) {
	var _s = dbg_group_state();
	_s[$ _title] = !dbg_group_expanded(_title);
}

function dbg_overlay_rows() {
	// Flat row list for the current collapse state. Each row: { kind:
	// "header"|"slider", y (center, relative to panel y1), title|def }.
	var _rows = [];
	var _y = 36; // below the panel title
	var _groups = dbg_slider_groups();
	for (var g = 0; g < array_length(_groups); g++) {
		var _grp = _groups[g];
		_y += 22;
		array_push(_rows, { kind: "header", title: _grp.title, y: _y });
		_y += 16;
		if (dbg_group_expanded(_grp.title)) {
			for (var i = 0; i < array_length(_grp.sliders); i++) {
				_y += 17;
				array_push(_rows, { kind: "slider", def: _grp.sliders[i], y: _y });
				_y += 18;
			}
		}
	}
	return { rows: _rows, end_y: _y };
}

function dbg_wave_header_y(_py1) {
	// The "Spawn Wave" header sits just below the last slider group, so the
	// section moves when groups are expanded or collapsed.
	return _py1 + dbg_overlay_rows().end_y + 26;
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
