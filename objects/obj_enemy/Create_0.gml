event_inherited();

armour = 1*difficulty_multiplier();

object_speed = 5;

hp = 100;

// Perlin-noise vertical bobbing (same noise helper the level-3 lightning uses).
// Each plane samples its own row of the noise field so they don't bob in sync.
bob_t         = 0;            // position in the noise field, advanced each step
bob_seed      = random(256);
bob_amplitude = 25;           // max vertical offset in px
bob_prev      = perlin_noise(0, bob_seed);
tilt_angle    = 0;

if(room == room_grasslands)
{
	image_xscale = 0.25;
	image_yscale = 0.25;
}

if(room == room_sunset)
{
	image_xscale = 0.15;
	image_yscale = 0.15;

	sprite_index = spr_british_aircraft;
	image_index = 0;
}

if(room == room_mountains)
{
	if(irandom(1) == 0)
	{
		image_xscale = 0.15;
		image_yscale = 0.15;
	
		sprite_index = spr_british_aircraft;
		image_index = 0;
	}

	else
	{
		image_xscale = 0.25;
		image_yscale = 0.25;
	
		sprite_index = spr_french_aircraft;
		image_index = 0;
	}
}