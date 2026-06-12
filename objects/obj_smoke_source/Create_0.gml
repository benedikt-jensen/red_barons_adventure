system = part_system_create_layer("Instances", 1);

type = part_type_create();
// no blending

part_type_sprite(type, spr_bullet_red_baron, true, false, false);

emitter = part_emitter_create(system);