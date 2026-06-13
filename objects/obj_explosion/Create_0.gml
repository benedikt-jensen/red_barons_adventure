play_sfx(snd_bomb_explosion, 0, 0);

depth = layer_get_depth(layer_get_id("Instances")) - 10;

image_xscale = 2.5;
image_yscale = 2.5;

//---------IMMERSION: shake the camera, stronger the closer the blast is
if (instance_exists(obj_red_baron)) {
	var _d = point_distance(x, y, obj_red_baron.x, obj_red_baron.y);
	camera_shake(0.5 * clamp(1 - _d / 900, 0, 1));
}