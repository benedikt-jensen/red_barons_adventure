// Health bar above the enemy, only while damaged
if (hp > 0 && hp < 100)
{
	bar_width  = sprite_width / 1.5;
	bar_height = sprite_height / 20;

	draw_healthbar(
		x - bar_width / 2, y - (sprite_height / 2 + bar_height),
		x + bar_width / 2, y - sprite_height / 2,
		hp, c_white, c_red, $3FFF00, 0, true, true);
}