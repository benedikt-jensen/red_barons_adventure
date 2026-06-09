/// @DnDAction : YoYo Games.Audio.Stop_Audio
/// @DnDVersion : 1
/// @DnDHash : 1D30E91C
/// @DnDArgument : "soundid" "missile_sound"
audio_stop_sound(missile_sound);

/// @DnDAction : YoYo Games.Audio.Play_Audio
/// @DnDVersion : 1.1
/// @DnDHash : 1E88E7D7
/// @DnDArgument : "soundid" "snd_missile_explode"
/// @DnDSaveInfo : "soundid" "snd_missile_explode"
play_sfx(snd_missile_explode, 0, 0);

/// @DnDAction : YoYo Games.Particles.Effect
/// @DnDVersion : 1
/// @DnDHash : 5075F5C3
/// @DnDArgument : "x_relative" "1"
/// @DnDArgument : "y_relative" "1"
/// @DnDArgument : "color" "$FFFFFFFF"
effect_create_below(0, x + 0, y + 0, 0, $FFFFFFFF & $ffffff);