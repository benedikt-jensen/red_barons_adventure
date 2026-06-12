event_inherited();

alarm_set(1, 300);

image_xscale = 0.85;
image_yscale = 0.85;

armour = 160;
hp = 100;

spawn_x_pos = x;
normal_x_pos = room_width - sprite_width / 2 ;

state = 0;

start_y = y;

float_x = 0;
float_y = pi/2;

lights = instance_create_layer(x + 0, y + 0, "Instances", obj_zeppelin_lights);
lights.depth += -1;
lights.zeppelin_id = id;

lantern_first = instance_create_depth_with_fixture(id,x-22,y+83,depth-1,obj_zeppelin_lantern);
lantern_second = instance_create_depth_with_fixture(id,x+87,y+106,depth-1,obj_zeppelin_lantern);
