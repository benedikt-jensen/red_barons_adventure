if(state == 0)
{
	if(!(x < normal_x_pos))
	{
		x += -max(1, min(15,0.015 * (x - normal_x_pos)));
		y += 0;
	}

	else
	{
		state = 1;
	
		float_x = 1.5*pi;
	
		alarm_set(3, irandom_range(0,1000));
	}
}

if(state == 1)
{
	x += 1 * sin(float_x);
}

if(state == 2)
{
	ram_acc += -0.2;

	x += ram_acc;
}

float_y = float_y+0.01;

float_x = float_x+0.02;

y = start_y + 100 * sin(float_y);

if(hp <= 0)
{
	instance_destroy();
}