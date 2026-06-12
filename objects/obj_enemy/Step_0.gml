if(hp <= 0)
{
	play_sfx(snd_explosion_3, 0, 0);

	global.destroyed_airplanes += 1;

	instance_destroy();
}

var _vx = object_speed * global.plane_speed_mult;
x += -_vx;

// Perlin-noise bobbing: apply the noise *delta* so the drift stacks on top
// of whatever y the plane spawned at. Strength is scaled live by the
// "Plane Bob" debug slider; "Bob Arc Len" sets how many steps one noise
// feature spans (longer = wider, lazier arcs). Advancing the phase
// incrementally keeps live slider changes smooth.
bob_t += 1 / max(global.plane_bob_arc, 1);
var _noise = perlin_noise(bob_t, bob_seed);
var _dy = (_noise - bob_prev) * bob_amplitude * global.plane_bob_mult;
bob_prev = _noise;
y += _dy;

// Point the nose along the actual flight path: the tilt is the angle of
// the velocity vector, so it scales naturally with bob strength and arc
// length and can never pin against an artificial min/max. The -180 offset
// is because enemy sprites face left.
var _tilt_target = angle_difference(point_direction(0, 0, -_vx, _dy), 180);
if (tilt_angle < _tilt_target) tilt_angle = min(tilt_angle + 2, _tilt_target);
if (tilt_angle > _tilt_target) tilt_angle = max(tilt_angle - 2, _tilt_target);
image_angle = tilt_angle;

if(x < -sprite_width / 2)
{
	instance_destroy();

	script_execute(damage_player, 20, 0);
}