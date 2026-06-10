/// @DnDAction : YoYo Games.Instances.Inherit_Event
/// @DnDVersion : 1
/// @DnDHash : 295AA2BE
event_inherited();

/// @DnDAction : YoYo Games.Common.Variable
/// @DnDVersion : 1
/// @DnDHash : 17FFCCA5
/// @DnDArgument : "expr" "1*difficulty_multiplier()"
/// @DnDArgument : "var" "armour"
armour = 1*difficulty_multiplier();

/// @DnDAction : YoYo Games.Common.Variable
/// @DnDVersion : 1
/// @DnDHash : 7D54AB2A
/// @DnDArgument : "expr" "random_range(3, 7 )"
/// @DnDArgument : "var" "object_speed"
object_speed = 5;

/// @DnDAction : YoYo Games.Instance Variables.Set_Health
/// @DnDVersion : 1
/// @DnDHash : 507A7886
/// @DnDArgument : "health" "100"

__dnd_health = real(100);

/// @DnDAction : YoYo Games.Common.If_Variable
/// @DnDVersion : 1
/// @DnDHash : 125D9D05
/// @DnDArgument : "var" "room"
/// @DnDArgument : "value" "room_grasslands"
if(room == room_grasslands)
{
	/// @DnDAction : YoYo Games.Instances.Sprite_Scale
	/// @DnDVersion : 1
	/// @DnDHash : 501AF386
	/// @DnDParent : 125D9D05
	/// @DnDArgument : "xscale" "0.25"
	/// @DnDArgument : "yscale" "0.25"
	image_xscale = 0.25;
	image_yscale = 0.25;
}

/// @DnDAction : YoYo Games.Common.If_Variable
/// @DnDVersion : 1
/// @DnDHash : 087AE269
/// @DnDArgument : "var" "room"
/// @DnDArgument : "value" "room_sunset"
if(room == room_sunset)
{
	/// @DnDAction : YoYo Games.Instances.Sprite_Scale
	/// @DnDVersion : 1
	/// @DnDHash : 2FDC6BBC
	/// @DnDParent : 087AE269
	/// @DnDArgument : "xscale" "0.15"
	/// @DnDArgument : "yscale" "0.15"
	image_xscale = 0.15;
	image_yscale = 0.15;

	/// @DnDAction : YoYo Games.Instances.Set_Sprite
	/// @DnDVersion : 1
	/// @DnDHash : 0935BFE9
	/// @DnDParent : 087AE269
	/// @DnDArgument : "spriteind" "spr_british_aircraft"
	/// @DnDSaveInfo : "spriteind" "spr_british_aircraft"
	sprite_index = spr_british_aircraft;
	image_index = 0;
}

/// @DnDAction : YoYo Games.Common.If_Variable
/// @DnDVersion : 1
/// @DnDHash : 393AE1DC
/// @DnDArgument : "var" "room"
/// @DnDArgument : "value" "room_mountains"
if(room == room_mountains)
{
	/// @DnDAction : YoYo Games.Common.If_Expression
	/// @DnDVersion : 1
	/// @DnDHash : 0487D877
	/// @DnDParent : 393AE1DC
	/// @DnDArgument : "expr" "irandom(1) == 0"
	if(irandom(1) == 0)
	{
		/// @DnDAction : YoYo Games.Instances.Sprite_Scale
		/// @DnDVersion : 1
		/// @DnDHash : 0C0B8DE3
		/// @DnDParent : 0487D877
		/// @DnDArgument : "xscale" "0.15"
		/// @DnDArgument : "yscale" "0.15"
		image_xscale = 0.15;
		image_yscale = 0.15;
	
		/// @DnDAction : YoYo Games.Instances.Set_Sprite
		/// @DnDVersion : 1
		/// @DnDHash : 05196E99
		/// @DnDParent : 0487D877
		/// @DnDArgument : "spriteind" "spr_british_aircraft"
		/// @DnDSaveInfo : "spriteind" "spr_british_aircraft"
		sprite_index = spr_british_aircraft;
		image_index = 0;
	}

	/// @DnDAction : YoYo Games.Common.Else
	/// @DnDVersion : 1
	/// @DnDHash : 48235E6E
	/// @DnDParent : 393AE1DC
	else
	{
		/// @DnDAction : YoYo Games.Instances.Sprite_Scale
		/// @DnDVersion : 1
		/// @DnDHash : 7083401C
		/// @DnDParent : 48235E6E
		/// @DnDArgument : "xscale" "0.25"
		/// @DnDArgument : "yscale" "0.25"
		image_xscale = 0.25;
		image_yscale = 0.25;
	
		/// @DnDAction : YoYo Games.Instances.Set_Sprite
		/// @DnDVersion : 1
		/// @DnDHash : 34008C56
		/// @DnDParent : 48235E6E
		/// @DnDArgument : "spriteind" "spr_french_aircraft"
		/// @DnDSaveInfo : "spriteind" "spr_french_aircraft"
		sprite_index = spr_french_aircraft;
		image_index = 0;
	}
}