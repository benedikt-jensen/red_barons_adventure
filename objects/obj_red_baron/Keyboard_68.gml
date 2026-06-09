/// @DnDAction : YoYo Games.Common.If_Variable
/// @DnDVersion : 1
/// @DnDHash : 2006DDFA
/// @DnDArgument : "var" "bullet_cooldown"
if(bullet_cooldown == 0)
{
	/// @DnDAction : YoYo Games.Common.Variable
	/// @DnDVersion : 1
	/// @DnDHash : 4DC91140
	/// @DnDParent : 2006DDFA
	/// @DnDArgument : "expr" "10"
	/// @DnDArgument : "var" "bullet_cooldown"
	bullet_cooldown = 10;

	/// @DnDAction : YoYo Games.Audio.Play_Audio
	/// @DnDVersion : 1.1
	/// @DnDHash : 6FBCA5F5
	/// @DnDParent : 2006DDFA
	/// @DnDArgument : "soundid" "snd_gunshot"
	/// @DnDSaveInfo : "soundid" "snd_gunshot"
	play_sfx(snd_gunshot, 0, 0);

	/// @DnDAction : YoYo Games.Instances.Create_Instance
	/// @DnDVersion : 1
	/// @DnDHash : 7DAD7348
	/// @DnDParent : 2006DDFA
	/// @DnDArgument : "xpos" "80"
	/// @DnDArgument : "xpos_relative" "1"
	/// @DnDArgument : "ypos_relative" "1"
	/// @DnDArgument : "objectid" "obj_bullet_red_baron"
	/// @DnDSaveInfo : "objectid" "obj_bullet_red_baron"
	instance_create_layer(x + 80, y + 0, "Instances", obj_bullet_red_baron);
}