/// Visual FX helpers (muzzle flash, ambient motes).
///
/// Particle types live on obj_controller (global.MuzzleParticle / MoteParticle,
/// defined in its Create). These functions are the single place that emits them.
/// Both effects are gated behind debug-overlay toggles and off by default.

/// @desc Quick additive glow at the Red Baron's guns, once per shot.
function emit_muzzle_flash(_x, _y) {
	if (!global.fx_muzzle) return;
	part_particles_create(global.part_system, _x, _y, global.MuzzleParticle, 2);
}

/// @desc Trickle of slow drifting dust/embers across the sky. Call each frame.
///       Skipped in grasslands (level 2), where it doesn't read well.
function spawn_ambient_motes() {
	if (!global.fx_motes) return;
	if (room != room_sunset && room != room_mountains) return;
	part_particles_create(global.part_system_background,
		random(room_width), random(room_height), global.MoteParticle, 1);
}
