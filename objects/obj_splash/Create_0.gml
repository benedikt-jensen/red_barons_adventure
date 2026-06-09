/// @DnDAction : YoYo Games.Audio.Play_Audio
/// @DnDVersion : 1.1
/// @DnDHash : 2B8059CF
/// @DnDArgument : "soundid" "snd_splash"
/// @DnDSaveInfo : "soundid" "snd_splash"
play_sfx(snd_splash, 0, 0);

/// @DnDAction : YoYo Games.Common.Variable
/// @DnDVersion : 1
/// @DnDHash : 4EE5F5F3
/// @DnDArgument : "expr" "layer_get_depth(layer_get_id("Instances")) - 10"
/// @DnDArgument : "var" "depth"
depth = layer_get_depth(layer_get_id("Instances")) - 10;

/// @DnDAction : YoYo Games.Instances.Color_Sprite
/// @DnDVersion : 1
/// @DnDHash : 665E3590
/// @DnDArgument : "colour" "$CCFFCCCC"
image_blend = $CCFFCCCC & $ffffff;
image_alpha = ($CCFFCCCC >> 24) / $ff;