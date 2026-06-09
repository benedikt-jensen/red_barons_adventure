/// @DnDAction : YoYo Games.Audio.Play_Audio
/// @DnDVersion : 1.1
/// @DnDHash : 2B8059CF
/// @DnDArgument : "soundid" "snd_bomb_explosion"
/// @DnDSaveInfo : "soundid" "snd_bomb_explosion"
play_sfx(snd_bomb_explosion, 0, 0);

/// @DnDAction : YoYo Games.Common.Variable
/// @DnDVersion : 1
/// @DnDHash : 4EE5F5F3
/// @DnDArgument : "expr" "layer_get_depth(layer_get_id("Instances")) - 10"
/// @DnDArgument : "var" "depth"
depth = layer_get_depth(layer_get_id("Instances")) - 10;

/// @DnDAction : YoYo Games.Instances.Sprite_Scale
/// @DnDVersion : 1
/// @DnDHash : 4CC3E09B
/// @DnDArgument : "xscale" "2.5"
/// @DnDArgument : "yscale" "2.5"
image_xscale = 2.5;
image_yscale = 2.5;