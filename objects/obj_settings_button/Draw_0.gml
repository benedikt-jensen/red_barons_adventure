/// @description Draw settings button

var col_bg = hovered ? make_color_rgb(100, 80, 50) : make_color_rgb(60, 50, 35);

draw_set_color(col_bg);
draw_rectangle(x - btn_hw, y - btn_hh, x + btn_hw, y + btn_hh, false);
draw_set_color(make_color_rgb(180, 145, 75));
draw_rectangle(x - btn_hw, y - btn_hh, x + btn_hw, y + btn_hh, true);

draw_set_color(c_white);
draw_set_font(font_gui_buttons);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x, y, "SETTINGS");

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
