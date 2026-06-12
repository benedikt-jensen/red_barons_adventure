instance_destroy();


part_particles_create(global.part_system, x, y, global.BulletParticle, 10)

with(other) {
	with(other) var l6C9A72AF_0 = on_fire == 1;
	if(l6C9A72AF_0)
	{
		hp += -other.damage*damage_multiplier()*1.5/ armour;
	}

	else
	{
		hp += -other.damage*damage_multiplier() / armour;
	}
}