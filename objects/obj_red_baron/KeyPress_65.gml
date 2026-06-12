if(missiles_powerup > 0)
{
	missiles_powerup += -1;

	missile_id = instance_create_layer(x + 80, y + 0, "Instances", obj_missile);

	with(missile_id) {
		image_xscale = 0.35;
		image_yscale = 0.35;
	}
}