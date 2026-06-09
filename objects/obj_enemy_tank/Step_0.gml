/// @DnDAction : YoYo Games.Instance Variables.If_Health
/// @DnDVersion : 1
/// @DnDHash : 4F25E5DA
/// @DnDArgument : "op" "3"
if(!variable_instance_exists(id, "__dnd_health")) __dnd_health = 0;
if(__dnd_health <= 0)
{
	/// @DnDAction : YoYo Games.Audio.Play_Audio
	/// @DnDVersion : 1.1
	/// @DnDHash : 0BA4AD6E
	/// @DnDParent : 4F25E5DA
	/// @DnDArgument : "soundid" "snd_big_explosion_metal"
	/// @DnDSaveInfo : "soundid" "snd_big_explosion_metal"
	play_sfx(snd_big_explosion_metal, 0, 0);

	/// @DnDAction : YoYo Games.Common.Variable
	/// @DnDVersion : 1
	/// @DnDHash : 36D047D6
	/// @DnDParent : 4F25E5DA
	/// @DnDArgument : "expr" "1"
	/// @DnDArgument : "expr_relative" "1"
	/// @DnDArgument : "var" "global.destroyed_airplanes"
	global.destroyed_airplanes += 1;

	/// @DnDAction : YoYo Games.Instances.Destroy_Instance
	/// @DnDVersion : 1
	/// @DnDHash : 2375E86B
	/// @DnDParent : 4F25E5DA
	instance_destroy();
}

/// @DnDAction : YoYo Games.Movement.Jump_To_Point
/// @DnDVersion : 1
/// @DnDHash : 03BDF602
/// @DnDArgument : "x" "- object_speed"
/// @DnDArgument : "x_relative" "1"
/// @DnDArgument : "y" "0"
/// @DnDArgument : "y_relative" "1"
x += - object_speed;
y += 0;

/// @DnDAction : YoYo Games.Common.If_Variable
/// @DnDVersion : 1
/// @DnDHash : 6AD1F73F
/// @DnDArgument : "var" "x"
/// @DnDArgument : "op" "1"
/// @DnDArgument : "value" "-sprite_width / 2"
if(x < -sprite_width / 2)
{
	/// @DnDAction : YoYo Games.Instances.Destroy_Instance
	/// @DnDVersion : 1
	/// @DnDHash : 59B162AB
	/// @DnDParent : 6AD1F73F
	instance_destroy();

	/// @DnDAction : YoYo Games.Common.Execute_Script
	/// @DnDVersion : 1.1
	/// @DnDHash : 4578D938
	/// @DnDInput : 2
	/// @DnDParent : 6AD1F73F
	/// @DnDArgument : "script" "damage_player"
	/// @DnDArgument : "arg" "20"
	/// @DnDArgument : "arg_1" "0"
	script_execute(damage_player, 20, 0);
}