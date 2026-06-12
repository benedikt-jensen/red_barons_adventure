if(bombs_powerup > 0)
{
	instance_create_layer(x + 0, y + 0, "Instances", obj_bomb);

	bombs_powerup += -1;
}