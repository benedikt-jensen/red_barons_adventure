script_execute(instance_destroy, lights);

script_execute(instance_destroy, lantern_first);

script_execute(instance_destroy, lantern_second);

instance_create_layer(x + 0, y + 0, "Instances", obj_explosion);

instance_create_layer(x + -180, y + 0, "Instances", obj_explosion);

instance_create_layer(x + 180, y + 0, "Instances", obj_explosion);


spawn_explosion(x,y);
level_done();
global.cheat_codes[? "invincible"] = true;