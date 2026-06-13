/// @description Screen shake: blit the composited frame back with an offset

// Auto-draw of the application surface is disabled in Create, so we draw it here.
// Drawing in Draw GUI Begin (not Post-Draw) means we work in GUI space, which
// always maps to the full window at any resolution; the HUD draws on top, steady.
if (!surface_exists(application_surface)) exit;

// Earlier draw events may have left a tint/alpha set; blit the frame opaque.
draw_set_color(c_white);
draw_set_alpha(1);

var _w = display_get_gui_width();
var _h = display_get_gui_height();

if (shake_x == 0 && shake_y == 0 && shake_angle == 0) {
	// At rest: draw the frame normally, no zoom, no gaps.
	draw_surface_stretched(application_surface, 0, 0, _w, _h);
	exit;
}

// Overscan just enough that the offset and rotation never expose a blank edge.
var _rad   = degtorad(abs(shake_angle));
var _need  = max(abs(shake_x), abs(shake_y)) + (_h * 0.5) * sin(_rad);
var _scale = 1 + 2 * (_need / min(_w, _h));

// Scale + rotate about the frame's centre, then translate by the shake offset.
var _cx = _w * 0.5;
var _cy = _h * 0.5;
matrix_set(matrix_world, matrix_build(
	_cx + shake_x, _cy + shake_y, 0,
	0, 0, shake_angle,
	_scale, _scale, 1));
draw_surface_stretched(application_surface, -_cx, -_cy, _w, _h);
matrix_set(matrix_world, matrix_build_identity());
