/// @DnDAction : YoYo Games.Common.If_Variable
/// @DnDVersion : 1
/// @DnDHash : 0AD4DF51
/// @DnDArgument : "var" "bullets_left"
if(bullets_left == 0)
{
	/// @DnDAction : YoYo Games.Instances.Set_Alarm
	/// @DnDVersion : 1
	/// @DnDHash : 3F1B1847
	/// @DnDParent : 0AD4DF51
	/// @DnDArgument : "steps" "180"
	alarm_set(0, 180);

	/// @DnDAction : YoYo Games.Common.Variable
	/// @DnDVersion : 1
	/// @DnDHash : 12395BD1
	/// @DnDParent : 0AD4DF51
	/// @DnDArgument : "expr" "fast_firing"
	/// @DnDArgument : "var" "bullets_left"
	bullets_left = fast_firing;
}

/// @DnDAction : YoYo Games.Common.Else
/// @DnDVersion : 1
/// @DnDHash : 521010BD
else
{
	/// @DnDAction : YoYo Games.Instances.Set_Alarm
	/// @DnDVersion : 1
	/// @DnDHash : 66F0D94C
	/// @DnDParent : 521010BD
	/// @DnDArgument : "steps" "22"
	alarm_set(0, 22);

	/// @DnDAction : YoYo Games.Common.Variable
	/// @DnDVersion : 1
	/// @DnDHash : 20F269DF
	/// @DnDParent : 521010BD
	/// @DnDArgument : "expr" "-1"
	/// @DnDArgument : "expr_relative" "1"
	/// @DnDArgument : "var" "bullets_left"
	bullets_left += -1;

	/// @DnDAction : YoYo Games.Common.Execute_Code
	/// @DnDVersion : 1
	/// @DnDHash : 2B7643A5
	/// @DnDParent : 521010BD
	/// @DnDArgument : "code" "/// @description Shoot$(13_10)$(13_10)var _x = gun_x + lengthdir_x(140,gun_direction) * image_xscale;$(13_10)var _y = gun_y + lengthdir_y(140,gun_direction) * image_yscale;$(13_10)var _bullet = instance_create_layer(_x,_y,layer,obj_enemy_bullet);$(13_10)play_sfx(snd_tank_gunshot, 0, 0)$(13_10)_bullet.direction= gun_direction;$(13_10)_bullet.speed = 15;$(13_10)_bullet.x_speed = 0//vel_x;$(13_10)_bullet.image_angle = gun_direction;"
	/// @description Shoot
	
	var _x = gun_x + lengthdir_x(140,gun_direction) * image_xscale;
	var _y = gun_y + lengthdir_y(140,gun_direction) * image_yscale;
	var _bullet = instance_create_layer(_x,_y,layer,obj_enemy_bullet);
	play_sfx(snd_tank_gunshot, 0, 0)
	_bullet.direction= gun_direction;
	_bullet.speed = 15;
	_bullet.x_speed = 0//vel_x;
	_bullet.image_angle = gun_direction;
}