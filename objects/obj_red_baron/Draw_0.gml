
/// @description Shoot Laser

laser_is_active = false;

if (global.input_shoot_laser) {
	if (laser_powerup>0) {
		laser_is_active = true;
		laser_powerup -= 0.02;
		laser_start_x = x + 70;
		laser_start_y = y;

		laser_end_x = laser_start_x;

		for (var i = 1; i<2000; i++) {
			laser_end_x++;
			var collision_id = collision_point(laser_start_x + i, laser_start_y, obj_enemy_parent, 1, 1)
			if (collision_id != noone || laser_end_x>room_width+200) {
				break;
			}
		}

		if (instance_exists(collision_id)) {
			with(collision_id) {
				hp -= 4 * damage_multiplier() / armour;
			}
		}
		part_particles_create(global.part_system_background, laser_start_x, laser_start_y, global.LaserBeamBase, 1);
		part_particles_create(global.part_system_background, laser_start_x, laser_start_y, global.LaserBeam, 1);
		part_particles_create(global.part_system_background, laser_start_x, laser_start_y, global.LaserBeamCore, 1);
		draw_set_alpha(0.5)
		gpu_set_blendmode(bm_add)
		draw_line_width_color(laser_start_x, laser_start_y, laser_end_x, laser_start_y, 10, c_red, c_red)
		draw_line_width_color(laser_start_x, laser_start_y, laser_end_x, laser_start_y, 5, c_white, c_white)
		gpu_set_blendmode(bm_normal)
		draw_set_alpha(1)
		part_particles_create(global.part_system, laser_end_x, laser_start_y, global.LaserParticle, 1);
	} else {
		audio_stop_sound(snd_laser);	
	}
}

draw_self();