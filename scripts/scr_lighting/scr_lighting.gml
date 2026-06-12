function draw_light(sprite,subimg,x,y,xscale,yscale,rot,col,alpha) {
	array_push(global.light_draw_commands,[sprite,subimg,x,y,xscale,yscale,rot,col,alpha])
}

function draw_sprite_ext_arr(args) {
	draw_sprite_ext(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
}

/// @description Takes a human-readable position for which row and spot the battler should be on and returns the correct position for their side of the field
/// @function battleGridDecode(enum:position, real:owner)
function draw_light_fire_bullet(){

}

function draw_light_laser(filter_surface) {
	with(obj_red_baron) {
		if (laser_is_active) {
			for (var i = 0; i<1; i++) {
				var intensity = i==1 ? 0.5 : 1;
				var blendmode = i==0 ? bm_subtract : bm_add;
				var col = c_white;
				if (room == room_sunset) {
					continue;
				}
				if (i==0) {
					surface_set_target(filter_surface);
				}
				gpu_set_blendmode(blendmode);
			
				// var target_length = laser_end_x - laser_start_x + sprite_get_width(spr_light_circle);
				// var x_scale = target_length / sprite_get_width(spr_light_circle);
				draw_sprite_ext(spr_light_circle,0,laser_start_x,y,1.5,1.5,0,col,intensity * (perlin_noise(current_time/300)+1)/4);
				draw_sprite_ext(spr_light_circle,0,laser_end_x,y,2,2,0,col,intensity * (perlin_noise(current_time/300)+1)/4);
			
				var xx = laser_start_x;
				while(xx < laser_end_x) {
					draw_sprite_ext(spr_light_circle,0,xx,y,0.4,0.4,0,col,intensity * (perlin_noise(current_time/300)+1)/2);
					xx += 30;
				}
				if (i==0) {
					surface_reset_target();
				}
				// STRETCH CIRCLE LIGHT draw_sprite_ext(spr_light_circle,0,(laser_end_x + laser_start_x)/2,laser_start_y,x_scale,1,0,c_white,(perlin_noise(current_time/300)+1)/2);
			}
			gpu_set_blendmode(bm_normal);
		}
	}
}

function draw_boss_laser(filter_surface, x1, y1, x2, y2) {
	var is_bright_level = (room == room_grasslands) ? 1 : 0;
	var intensity = [1, 5, 0.8];
	var blendmode = [bm_subtract, bm_add, bm_add];
	var col = [c_white, c_aqua, c_white];
	var thickness = [1,0.9,1];
	for (var i = 0; i<=(2+is_bright_level); i++) {
		if (i==0) {
			surface_set_target(filter_surface);
		}
		gpu_set_blendmode(blendmode[i]);
			
		// var target_length = laser_end_x - laser_start_x + sprite_get_width(spr_light_circle);
		// var x_scale = target_length / sprite_get_width(spr_light_circle);
		draw_sprite_ext(spr_light_circle,0,x1,y1,1.5*thickness[i],1.5*thickness[i],0,col[i],intensity[i] * (perlin_noise(current_time/300)+1)/4);
		draw_sprite_ext(spr_light_circle,0,x2,y2,2*thickness[i],2*thickness[i],0,col[i],intensity[i] * (perlin_noise(current_time/300)+1)/4);
			
		var _mag = v_mag([x2-x1,y2-y1]);
		var _norm = v_norm([x2-x1,y2-y1]);
		for(var j=0;j<_mag;j=j+30) {
			draw_sprite_ext(spr_light_circle,0,x1+j*_norm[0],y1+j*_norm[1],0.4*thickness[i],0.4*thickness[i],0,col[i],intensity[i] * (perlin_noise(current_time/300)+1)/2);
		}
		if (i==0) {
			surface_reset_target();
		}
	}
	gpu_set_blendmode(bm_normal);
}