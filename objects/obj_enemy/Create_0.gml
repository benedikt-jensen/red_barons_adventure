event_inherited();

armour = 1*difficulty_multiplier();

object_speed = 5;


hp = 100;

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