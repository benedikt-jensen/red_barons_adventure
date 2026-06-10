/// @DnDAction : YoYo Games.Common.If_Expression
/// @DnDVersion : 1
/// @DnDHash : 15FEA073
/// @DnDArgument : "expr" "room==room_grasslands && !boss_spawned"
if(room==room_grasslands && !boss_spawned)
{
	/// @DnDAction : YoYo Games.Common.Function_Call
	/// @DnDVersion : 1
	/// @DnDHash : 12933644
	/// @DnDInput : 3
	/// @DnDParent : 15FEA073
	/// @DnDArgument : "function" "spawn_vehicle"
	/// @DnDArgument : "arg" "obj_enemy_tank"
	/// @DnDArgument : "arg_1" "1.5"
	/// @DnDArgument : "arg_2" "1.5"
	spawn_vehicle(obj_enemy_tank, 1.5, 1.5);
}

/// @DnDAction : YoYo Games.Instances.Set_Alarm
/// @DnDVersion : 1
/// @DnDHash : 0090EC95
/// @DnDArgument : "steps" "random_range(250,500)"
/// @DnDArgument : "alarm" "5"
alarm_set(5, random_range(250,500));

/// @DnDAction : YoYo Games.Common.Execute_Code
/// @DnDVersion : 1
/// @DnDHash : 01562B49
/// @DnDArgument : "code" "/// @description Spawn tanks$(13_10)"
/// @description Spawn tanks