if(room == room_grasslands)
{
	if(y >= room_height - 137)
	{
		instance_destroy();
	
		instance_create_layer(x + 0, y + 0, "Instances", obj_explosion);
	}
}

else
{
	if(room == room_sunset)
	{
		if(y >= global.y_limit)
		{
			instance_destroy();
		
			instance_create_layer(x + 0, global.y_limit, "Instances", obj_splash);
		}
	}

	else
	{
		if(y >= room_height + 100)
		{
			instance_destroy();
		}
	}
}


y += 15;

/// @description rotate downwards

target_angle = -90;

angle_diff = target_angle - image_angle;
image_angle += angle_diff / 20;