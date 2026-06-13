/// @description Draw settings panel overlay

var col_bg     = make_color_rgb(30, 25, 18);
var col_border = make_color_rgb(180, 145, 75);
var col_title  = make_color_rgb(255, 210, 100);
var col_label  = make_color_rgb(210, 190, 150);
var col_track  = make_color_rgb(75, 65, 50);
var col_fill   = make_color_rgb(195, 155, 70);
var col_thumb  = make_color_rgb(255, 220, 110);
var col_pct    = make_color_rgb(180, 165, 130);

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Dim overlay
draw_set_alpha(0.65);
draw_set_color(c_black);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);

// Panel background
draw_set_color(col_bg);
draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, false);
draw_set_color(col_border);
draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, true);

// Title
draw_set_font(font_gui_buttons);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(col_title);
draw_text(panel_x + panel_w * 0.5, panel_y + 50, "SETTINGS");

// Sliders
var labels = ["Master Volume", "Music", "Sound Effects"];
var values = [global.master_volume, global.music_volume, global.sfx_volume];
var lbl_x = panel_x + 30;

draw_set_font(font_gui_buttons);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

for (var i = 0; i < 3; i++) {
    var ty  = track_y[i];
    var val = values[i];
    var tx_end = track_x + track_w * val;

    draw_set_color(col_label);
    draw_text(lbl_x, ty, labels[i]);

    draw_set_color(col_track);
    draw_rectangle(track_x, ty - track_h * 0.5, track_x + track_w, ty + track_h * 0.5, false);

    draw_set_color(col_fill);
    if val > 0 draw_rectangle(track_x, ty - track_h * 0.5, tx_end, ty + track_h * 0.5, false);

    draw_set_color(col_thumb);
    draw_circle(tx_end, ty, thumb_r, false);

    draw_set_color(col_pct);
    draw_set_halign(fa_left);
    draw_text(track_x + track_w + 16, ty, string(round(val * 100)) + "%");
}

// Soft Maneuvering toggle
draw_set_halign(fa_left);
draw_set_color(col_label);
draw_text(lbl_x, toggle_cy, "Soft Maneuvering");

draw_set_color(col_track);
draw_rectangle(toggle_cx - toggle_hs, toggle_cy - toggle_hs, toggle_cx + toggle_hs, toggle_cy + toggle_hs, false);
draw_set_color(col_border);
draw_rectangle(toggle_cx - toggle_hs, toggle_cy - toggle_hs, toggle_cx + toggle_hs, toggle_cy + toggle_hs, true);
if (global.soft_maneuvering) {
    draw_set_color(col_fill);
    draw_rectangle(toggle_cx - toggle_hs + 5, toggle_cy - toggle_hs + 5, toggle_cx + toggle_hs - 5, toggle_cy + toggle_hs - 5, false);
}

draw_set_color(col_pct);
draw_text(toggle_cx + toggle_hs + 16, toggle_cy, global.soft_maneuvering ? "ON" : "OFF");

// Close button
var close_hover = abs(mx - close_cx) < close_hw && abs(my - close_cy) < close_hh;
draw_set_color(close_hover ? make_color_rgb(160, 60, 40) : make_color_rgb(110, 35, 25));
draw_rectangle(close_cx - close_hw, close_cy - close_hh, close_cx + close_hw, close_cy + close_hh, false);
draw_set_color(col_border);
draw_rectangle(close_cx - close_hw, close_cy - close_hh, close_cx + close_hw, close_cy + close_hh, true);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(close_cx, close_cy, "CLOSE");

// Reset draw state
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
