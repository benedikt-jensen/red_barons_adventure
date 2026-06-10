/// @DnDAction : YoYo Games.Common.If_Expression
/// @DnDVersion : 1
/// @DnDHash : 383431D7
/// @DnDArgument : "expr" "room==room_grasslands"
if(room==room_grasslands)
{
	/// @DnDAction : YoYo Games.Common.If_Variable
	/// @DnDVersion : 1
	/// @DnDHash : 4FA92BB5
	/// @DnDParent : 383431D7
	/// @DnDArgument : "var" "random(10)"
	/// @DnDArgument : "op" "1"
	/// @DnDArgument : "value" "1"
	if(random(10) < 1 * global.plant_spawn_mult)
	{
		/// @DnDAction : YoYo Games.Common.Function_Call
		/// @DnDVersion : 1
		/// @DnDHash : 0F0EF9D1
		/// @DnDParent : 4FA92BB5
		/// @DnDArgument : "function" "spawn_on_ground"
		/// @DnDArgument : "arg" "obj_plant"
		spawn_on_ground(obj_plant);
	}

	/// @DnDAction : YoYo Games.Common.If_Variable
	/// @DnDVersion : 1
	/// @DnDHash : 097CC73E
	/// @DnDParent : 383431D7
	/// @DnDArgument : "var" "random(10)"
	/// @DnDArgument : "op" "1"
	/// @DnDArgument : "value" "1"
	if(random(10) < 1 * global.tree_spawn_mult)
	{
		/// @DnDAction : YoYo Games.Common.Function_Call
		/// @DnDVersion : 1
		/// @DnDHash : 60B0E829
		/// @DnDInput : 3
		/// @DnDParent : 097CC73E
		/// @DnDArgument : "function" "spawn_on_ground"
		/// @DnDArgument : "arg" "obj_tree"
		/// @DnDArgument : "arg_1" "1"
		/// @DnDArgument : "arg_2" "2"
		spawn_on_ground(obj_tree, 1, 2);
	}

	/// @DnDAction : YoYo Games.Common.If_Variable
	/// @DnDVersion : 1
	/// @DnDHash : 72F29CCD
	/// @DnDParent : 383431D7
	/// @DnDArgument : "var" "random(6)"
	/// @DnDArgument : "op" "1"
	/// @DnDArgument : "value" "1"
	if(random(6) < 1 * global.rock_spawn_mult)
	{
		/// @DnDAction : YoYo Games.Common.Function_Call
		/// @DnDVersion : 1
		/// @DnDHash : 252D278C
		/// @DnDInput : 3
		/// @DnDParent : 72F29CCD
		/// @DnDArgument : "function" "spawn_on_ground"
		/// @DnDArgument : "arg" "obj_rock"
		/// @DnDArgument : "arg_1" "0.3"
		/// @DnDArgument : "arg_2" "1.3"
		spawn_on_ground(obj_rock, 0.3, 1.3);
	}
}

/// @DnDAction : YoYo Games.Instances.Set_Alarm
/// @DnDVersion : 1
/// @DnDHash : 77ECCFDD
/// @DnDArgument : "steps" "random_range(5,10)"
/// @DnDArgument : "alarm" "4"
alarm_set(4, random_range(5,10));

/// @DnDAction : YoYo Games.Common.Execute_Code
/// @DnDVersion : 1
/// @DnDHash : 30A1CB25
/// @DnDArgument : "code" "/// @description Spawn decorations$(13_10)"
/// @description Spawn decorations