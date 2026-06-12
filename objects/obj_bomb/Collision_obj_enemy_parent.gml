instance_destroy();

if(other.object_index ==obj_enemy_tank)
{
	instance_create_layer(other.x, 635, "Instances", obj_explosion);
}

else
{
	instance_create_layer(other.x, other.y, "Instances", obj_explosion);
}

with(other) {
	hp += -250 * damage_multiplier() / armour;
}