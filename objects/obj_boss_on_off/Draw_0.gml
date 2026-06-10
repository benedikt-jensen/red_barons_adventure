darken_on_hover();

var _color = multiply_colors(c_white, image_blend);
var _canActivate = global.highest_unlocked_boss[global.difficulty_level] >= global.start_from_level;
draw_sprite_ext(sprite_index, _canActivate ? (global.start_from_boss ? 1 : 2) : 0,x,y,image_xscale,image_yscale,image_angle,_color,1);