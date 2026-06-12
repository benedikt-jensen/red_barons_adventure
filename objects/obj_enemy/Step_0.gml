if(hp <= 0)
{
	play_sfx(snd_explosion_3, 0, 0);

	global.destroyed_airplanes += 1;

	instance_destroy();
}

x += - object_speed * global.plane_speed_mult;

// Perlin-noise bobbing: apply the noise *delta* so the drift stacks on top
// of whatever y the plane spawned at.
bob_timer += 1;
var _bob = perlin_noise(bob_timer * bob_frequency, bob_seed) * bob_amplitude;
var _dy = _bob - bob_prev;
bob_prev = _bob;
y += _dy;

// Tilt into the vertical motion like the player does (eased, capped at
// +/-10 degrees). Sign is flipped vs the player because enemy sprites face
// left: descending = nose down = counterclockwise = positive image_angle.
var _tilt_target = clamp(_dy * 10, -10, 10);
if (tilt_angle < _tilt_target) tilt_angle = min(tilt_angle + 2, _tilt_target);
if (tilt_angle > _tilt_target) tilt_angle = max(tilt_angle - 2, _tilt_target);
image_angle = tilt_angle;

if(x < -sprite_width / 2)
{
	instance_destroy();

	script_execute(damage_player, 20, 0);
}