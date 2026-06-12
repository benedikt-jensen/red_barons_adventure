event_inherited();

alarm_set(0, 30);

armour = 1.5*difficulty_multiplier();

object_speed = 8;


hp = 100;

image_xscale = 0.5;
image_yscale = 0.5;

/// @description spawn gun

new_tank_gun(id,-55*image_xscale, -160*image_yscale, 1, 1);