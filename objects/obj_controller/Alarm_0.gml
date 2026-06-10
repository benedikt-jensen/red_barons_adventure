/// @DnDAction : YoYo Games.Common.Execute_Code
/// @DnDVersion : 1
/// @DnDHash : 56C4A861
/// @DnDArgument : "code" "/// @description Spawn enemy plane$(13_10)$(13_10)if (room == room_sunset) {$(13_10)	frequency = boss_spawned ? 0 : 2;$(13_10)} else {$(13_10)	frequency = 1;$(13_10)}"
/// @description Spawn enemy plane

if (room == room_sunset) {
	frequency = boss_spawned ? 0 : 2;
} else {
	frequency = 1;
}

/// @DnDAction : YoYo Games.Common.If_Variable
/// @DnDVersion : 1
/// @DnDHash : 71EF4A74
/// @DnDArgument : "var" "in_game"
/// @DnDArgument : "value" "1"
if(in_game == 1)
{
	/// @DnDAction : YoYo Games.Common.If_Variable
	/// @DnDVersion : 1
	/// @DnDHash : 24FBA7D0
	/// @DnDParent : 71EF4A74
	/// @DnDArgument : "var" "room"
	/// @DnDArgument : "value" "room_grasslands"
	if(room == room_grasslands)
	{
		/// @DnDAction : YoYo Games.Instances.Set_Alarm
		/// @DnDVersion : 1
		/// @DnDHash : 00E53BCA
		/// @DnDParent : 24FBA7D0
		/// @DnDArgument : "steps" "random_range(45,100) / frequency"
		alarm_set(0, random_range(45,100) / frequency);
	
		/// @DnDAction : YoYo Games.Common.If_Variable
		/// @DnDVersion : 1
		/// @DnDHash : 401F6C80
		/// @DnDParent : 24FBA7D0
		/// @DnDArgument : "var" "boss_spawned"
		/// @DnDArgument : "value" "1"
		if(boss_spawned == 1)
		{
			/// @DnDAction : YoYo Games.Common.Function_Call
			/// @DnDVersion : 1
			/// @DnDHash : 0A2DCFFA
			/// @DnDInput : 3
			/// @DnDParent : 401F6C80
			/// @DnDArgument : "function" "spawn_on_right_limit_y"
			/// @DnDArgument : "arg" "obj_enemy"
			/// @DnDArgument : "arg_1" "0"
			/// @DnDArgument : "arg_2" "global.y_limit-200"
			spawn_on_right_limit_y(obj_enemy, 0, global.y_limit-200);
		}
	
		/// @DnDAction : YoYo Games.Common.Else
		/// @DnDVersion : 1
		/// @DnDHash : 00B8BC2A
		/// @DnDParent : 24FBA7D0
		else
		{
			/// @DnDAction : YoYo Games.Common.Function_Call
			/// @DnDVersion : 1
			/// @DnDHash : 215CDFF7
			/// @DnDInput : 3
			/// @DnDParent : 00B8BC2A
			/// @DnDArgument : "function" "spawn_on_right_limit_y"
			/// @DnDArgument : "arg" "obj_enemy"
			/// @DnDArgument : "arg_1" "0"
			/// @DnDArgument : "arg_2" "global.y_limit-100"
			spawn_on_right_limit_y(obj_enemy, 0, global.y_limit-100);
		}
	}

	/// @DnDAction : YoYo Games.Common.Else
	/// @DnDVersion : 1
	/// @DnDHash : 354CFDEF
	/// @DnDParent : 71EF4A74
	else
	{
		/// @DnDAction : YoYo Games.Instances.Set_Alarm
		/// @DnDVersion : 1
		/// @DnDHash : 53C3924D
		/// @DnDParent : 354CFDEF
		/// @DnDArgument : "steps" "random_range(45,100) / frequency"
		alarm_set(0, random_range(45,100) / frequency);
	
		/// @DnDAction : YoYo Games.Common.Function_Call
		/// @DnDVersion : 1
		/// @DnDHash : 5F9431AD
		/// @DnDInput : 3
		/// @DnDParent : 354CFDEF
		/// @DnDArgument : "function" "spawn_on_right_limit_y"
		/// @DnDArgument : "arg" "obj_enemy"
		/// @DnDArgument : "arg_1" "0"
		/// @DnDArgument : "arg_2" "room==room_sunset&&boss_spawned ? room_height/3 : global.y_limit"
		spawn_on_right_limit_y(obj_enemy, 0, room==room_sunset&&boss_spawned ? room_height/3 : global.y_limit);
	}
}