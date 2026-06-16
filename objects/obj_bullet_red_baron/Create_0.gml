/// @description Create

// Muzzle flash where the shot leaves the guns
emit_muzzle_flash(x, y);

on_fire = false;
damage = 33.4;

if instance_exists(obj_red_baron) && obj_red_baron.fire_bullets_powerup {
	obj_red_baron.fire_bullets_powerup -= 1;
	on_fire = true;
}

if on_fire {
	fire_trail_emitter = part_emitter_create(global.part_system);
	part_emitter_stream(global.part_system, fire_trail_emitter, global.FireParticle, 3);
}