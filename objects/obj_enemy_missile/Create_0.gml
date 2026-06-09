/// @DnDAction : YoYo Games.Common.Variable
/// @DnDVersion : 1
/// @DnDHash : 7DADA8AC
/// @DnDArgument : "expr" "240"
/// @DnDArgument : "var" "alarm[0]"
alarm[0] = 240;

/// @DnDAction : YoYo Games.Common.Variable
/// @DnDVersion : 1
/// @DnDHash : 2D029D10
/// @DnDArgument : "expr" "180"
/// @DnDArgument : "var" "direction"
direction = 180;

/// @DnDAction : YoYo Games.Instances.Sprite_Scale
/// @DnDVersion : 1
/// @DnDHash : 5DB4CF8D
/// @DnDArgument : "xscale" "0.22"
/// @DnDArgument : "yscale" "0.22"
image_xscale = 0.22;
image_yscale = 0.22;

/// @DnDAction : YoYo Games.Common.Variable
/// @DnDVersion : 1
/// @DnDHash : 493BCFA5
/// @DnDArgument : "expr" "undefined"
/// @DnDArgument : "var" "target_obj"
target_obj = undefined;

/// @DnDAction : YoYo Games.Audio.Play_Audio
/// @DnDVersion : 1.1
/// @DnDHash : 10F950A5
/// @DnDArgument : "target" "missile_sound"
/// @DnDArgument : "soundid" "snd_missile_launch"
/// @DnDSaveInfo : "soundid" "snd_missile_launch"
missile_sound = play_sfx(snd_missile_launch, 0, 0);