event_inherited();

alarm_set(2, 180);
alarm_set(0, 180);
alarm_set(3, 120);

baron_in_reach_machine_gun = false;
baron_in_reach_left_gun = false;

x_dir = 1;
laser_damage = 3;

machine_gun_min_angle = 0;
machine_gun_max_angle = 60;

gun_min_angle = 120;
gun_max_angle = 230;

laser_min_angle = 10;
laser_max_angle = 170;

laser_gun_direction = laser_max_angle;
laser_on = 0;
laser_shoot = 0;

fast_firing = 4;
bullets_left = fast_firing;
gun_direction = 0;

is_entering = 1;

armour = 80; // *difficulty_multiplier();

max_speed_mag = 4;

hp = 100;

image_xscale = 0.8;
image_yscale = 0.8;

min_x = sprite_width / 2 +10;
max_x = room_width - (sprite_width / 2 + 10);

acc_x = 0;

vel_x = -max_speed_mag;

laser_sound = undefined;

// spawn machine_gun
machinegun = new_gun(id, 148, -195, -1);
machinegun.min_angle = -45;
machinegun.max_angle = 80;
machinegun.target_id = obj_red_baron;
machinegun.shooting_pattern = get_shooting_pattern(ShootingPatterns.MachineGun);
machinegun.shoot_sound = snd_gunshot;
machinegun.shoot_sound_gain = 0.5;
machinegun.image_angle_offset = -13;
machinegun.next_shot = irandom(60);
machinegun.rotation_speed = 2;
machinegun.sprite_index = spr_machine_gun;
machinegun.bullet_type = get_bullet_type(BulletTypes.MachineGun);
machinegun.length = 70;
machinegun.image_xscale = image_xscale;
machinegun.image_yscale = image_xscale;