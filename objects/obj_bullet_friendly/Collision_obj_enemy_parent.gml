/// @description 
instance_destroy();


part_particles_create(global.part_system, x, y, global.BulletParticle, 10)

with(other) {
	if(other.on_fire == 1)
	{
		hp += -other.damage*damage_multiplier()*1.5 / armour;
	}

	else
	{
		hp += -other.damage*damage_multiplier() / armour;
	}
}