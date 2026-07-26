/// @description Hier Beschreibung einfügen

// Surfaces are volatile 
// Always check that they haven't been destroyed

var darkness = 0;

if (room == room_sunset) {
	if (surface_exists(filter_surface)) {
	    surface_set_target(filter_surface);
		draw_clear_alpha(c_black, 0.1);

		with(obj_filter_parent) {
			// Birds bake their dusk tint into image_blend instead (see
			// obj_bird.apply_distance): stamping them here would darken
			// anything their silhouette overlaps, casting fake shadows
			// onto objects in front of them.
			if (object_index == obj_bird) continue;
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_black, 0.9);
		}

		with(obj_bullet_red_baron) {
			if on_fire {
				surface_reset_target();
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_light_circle, 0, x, y, 0.3, 0.3, 0, c_yellow, 0.3);
				surface_set_target(other.filter_surface);
				gpu_set_blendmode(bm_subtract);
				draw_sprite_ext(spr_light_circle, 0, x, y, 1, 1, 0, c_white, 0.8);
				gpu_set_blendmode(bm_normal);
			}
		}
		
		with(obj_boss_ship) {
			var lamp_positions = [[x-200,y-140],[x+200,y-140]];
			for (i=0; i<array_length(lamp_positions);i++) {
				pos = lamp_positions[i];
				surface_reset_target();
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_light_circle, 0, pos[0], pos[1], 0.5, 0.5, 0, c_yellow, 0.3);
				surface_set_target(other.filter_surface);
				gpu_set_blendmode(bm_subtract);
				draw_sprite_ext(spr_light_circle, 0, pos[0], pos[1], 2.5, 2.0, 0, c_white, 0.8);
				gpu_set_blendmode(bm_normal);
			}
			if (laser_on) {
				draw_boss_laser(other.filter_surface, laser_start_x, laser_start_y, laser_end_x, laser_end_y);
			}
		}
		
		draw_light_laser(filter_surface);
	
	    surface_reset_target();
	} else {
	    filter_surface = surface_create(room_width, room_height);
	    surface_set_target(filter_surface);
	    draw_clear_alpha(c_black, 0);
	    surface_reset_target();
	}
}

if (room == room_mountains) {
	darkness = 0.1;
	if (surface_exists(filter_surface)) {
	    surface_set_target(filter_surface);
		draw_clear_alpha(c_black, 1);
		
		// draw stars and moon
		gpu_set_blendmode(bm_subtract);
		draw_sprite_ext(bg_night_lights,0,0,0,
			room_width/sprite_get_width(bg_night_lights), room_height/sprite_get_height(bg_night_lights),
			0,c_white,0.5);
		gpu_set_blendmode(bm_normal);
		with(all) {
			if (object_is_ancestor(object_index, obj_ui_parent) || object_is_ancestor(object_index, obj_ui_parent_1)) continue;
			if (sprite_exists(sprite_index)) {
				draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,0,c_black,1);
			}
		}

		with(obj_bullet_red_baron) {
			if on_fire {
				surface_reset_target();
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_light_circle, 0, x, y, 0.3, 0.3, 0, c_yellow, 0.3);
				surface_set_target(other.filter_surface);
				gpu_set_blendmode(bm_subtract);
				draw_sprite_ext(spr_light_circle, 0, x, y, 1, 1, 0, c_white, 0.8);
				gpu_set_blendmode(bm_normal);
			}
		}
		
		with(obj_red_baron) {
			if (light_is_on) {
				gpu_set_blendmode(bm_subtract);
				draw_sprite_ext(spr_light_cone, 0, x+lengthdir_x(68,image_angle), y+lengthdir_y(6,image_angle+90)+lengthdir_y(68,image_angle), 1, 1, image_angle, c_white, 0.5);
				gpu_set_blendmode(bm_normal);
			}
		}
		
		draw_light_laser(filter_surface);

		gpu_set_blendmode(bm_subtract);
		
		var lightning_brightness = 1.4 * lightning_intensity * (((perlin_noise(current_time/100)+1.3)+0.05*(perlin_noise(current_time/20)+1))/2.1)
		draw_sprite_ext(lightning_light_sprites[lightning_index],0,0,0,1,1,0,c_white,lightning_brightness);
		
		gpu_set_blendmode(bm_normal);
	
	    surface_reset_target();
	}
}

if (room == room_sunset || room == room_mountains) {
	if (!surface_exists(filter_surface)) {
	    filter_surface = surface_create(room_width, room_height);
	    surface_set_target(filter_surface);
	    draw_clear_alpha(c_black, 0);
	    surface_reset_target();
	} else {
		surface_set_target(filter_surface);
		
		// draw lights enqueued with draw_light
		gpu_set_blendmode(bm_subtract);
		for(var i=0; i<array_length(global.light_draw_commands); i++) {
			draw_sprite_ext_arr
			(global.light_draw_commands[i]);
		}
		global.light_draw_commands = [];
		
		gpu_set_blendmode(bm_normal);
		surface_reset_target();
		
	    if (view_current == 0) {
	        draw_surface_ext(filter_surface, 0, 0, 1, 1, 0, c_white, 1-darkness);
	    }
	}
}

// Draw red baron damage_cooldown blinking
with (obj_red_baron) {
	if (damage_cooldown == 0) continue;
	var phase = 20;
	var xx = damage_cooldown mod phase;
	var _alpha = (abs(xx - phase/2) / (phase/2));
	gpu_set_fog(true,c_white,0,1);
	draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,
		image_angle,c_white,_alpha);
	gpu_set_fog(false,c_white,0,1);
}