/// @description draw self and gun

gun_x = x-112*image_xscale;
gun_y = y-204*image_yscale;

machine_gun_x = x+130*image_xscale;
machine_gun_y = y-240*image_yscale;

laser_gun_x = x-20*image_xscale;
laser_gun_y = y-290*image_yscale;
var laser_gun_rot_speed = 0.35;

var baron_out_of_reach = true;
with(obj_red_baron) {
	// gun
	if (x > other.x) {
		other.gun_direction = other.gun_min_angle;
		other.baron_in_reach_left_gun = false;
	} else {
		other.gun_direction = clamp(point_direction(other.gun_x,other.gun_y,x,y), other.gun_min_angle, other.gun_max_angle);
		other.baron_in_reach_left_gun = true;
	}
	
	// machine_gun
		if (x > other.x) {
		other.machine_gun_direction = other.machine_gun_min_angle;
		other.baron_in_reach_machine_gun = false;
	} else {
		other.machine_gun_direction = clamp(point_direction(other.machine_gun_x,other.machine_gun_y,x,y), other.gun_min_angle, other.gun_max_angle);
		other.baron_in_reach_machine_gun = true;
	}
	
	// laser_gun
	var to_baron = point_direction(other.laser_gun_x,other.laser_gun_y,x,y)
	if (to_baron>270) {
		to_baron = 0;
	}
	other.desired_laser_gun_direction = to_baron;
	other.laser_gun_direction = clamp(other.laser_gun_direction+laser_gun_rot_speed*sign(other.desired_laser_gun_direction-other.laser_gun_direction), other.laser_min_angle, other.laser_max_angle);
	baron_out_of_reach = to_baron > other.laser_max_angle || to_baron < other.laser_min_angle;
}


var _norm = [lengthdir_x(1,laser_gun_direction), lengthdir_y(1,laser_gun_direction)];

if (laser_on) {
	laser_end_x = laser_gun_x;
	laser_end_y = laser_gun_y;
	var max_length = max(max(abs(laser_gun_x), abs(room_width-laser_gun_x)), abs(laser_gun_y)) + 200;
	var gun_length = 125;
	laser_start_x = laser_gun_x+_norm[0]*gun_length;
	laser_start_y = laser_gun_y+_norm[1]*gun_length;
	for (var i = gun_length; i<max_length; i=i+30) {
		var _x = laser_gun_x+i*_norm[0];
		var _y = laser_gun_y+i*_norm[1];
		laser_end_x = _x;
		laser_end_y = _y;
		if instance_exists(obj_red_baron) {
			if (collision_line(laser_gun_x, laser_gun_y, _x, _y, obj_red_baron, true, true)) {
				var _damage = laser_damage / obj_red_baron.armour * difficulty_multiplier();
				obj_controller.hp = max(0,obj_controller.hp-_damage)
				break;
			}
		}
	}
}

draw_sprite_ext(spr_boss_ship_gun,0,laser_gun_x, laser_gun_y,image_xscale,image_yscale,laser_gun_direction -90,c_white,1);
draw_self()
draw_sprite_ext(spr_boss_ship_left_gun,0,gun_x,gun_y,image_xscale,image_yscale,gun_direction,c_white,1);
