/// @DnDAction : YoYo Games.Common.Execute_Code
/// @DnDVersion : 1
/// @DnDHash : 3D701C00
/// @DnDArgument : "code" "damage_player(15, 0);"
damage_player(15, 0);

/// @DnDAction : YoYo Games.Audio.Play_Audio
/// @DnDVersion : 1.1
/// @DnDHash : 5726155C
/// @DnDArgument : "soundid" "snd_explosion_3"
/// @DnDSaveInfo : "soundid" "snd_explosion_3"
play_sfx(snd_explosion_3, 0, 0);

/// @DnDAction : YoYo Games.Common.Variable
/// @DnDVersion : 1
/// @DnDHash : 2C3D530D
/// @DnDArgument : "expr" "1"
/// @DnDArgument : "expr_relative" "1"
/// @DnDArgument : "var" "global.destroyed_airplanes"
global.destroyed_airplanes += 1;

/// @DnDAction : YoYo Games.Instances.Destroy_Instance
/// @DnDVersion : 1
/// @DnDHash : 030AFE1E
instance_destroy();