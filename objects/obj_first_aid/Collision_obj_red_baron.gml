/// @DnDAction : YoYo Games.Audio.Play_Audio
/// @DnDVersion : 1.1
/// @DnDHash : 1AF9E877
/// @DnDArgument : "soundid" "snd_first_aid"
/// @DnDSaveInfo : "soundid" "snd_first_aid"
play_sfx(snd_first_aid, 0, 0);

/// @DnDAction : YoYo Games.Common.Apply_To
/// @DnDVersion : 1
/// @DnDHash : 0632EE7E
/// @DnDApplyTo : {obj_controller}
with(obj_controller) {
	/// @DnDAction : YoYo Games.Instance Variables.Get_Health
	/// @DnDVersion : 1
	/// @DnDHash : 00B82CA6
	/// @DnDParent : 0632EE7E
	/// @DnDArgument : "var" "lastHealth"
	/// @DnDArgument : "var_temp" "1"
	if(!variable_instance_exists(id, "__dnd_health")) __dnd_health = 0;
	var lastHealth = __dnd_health;

	/// @DnDAction : YoYo Games.Instance Variables.Set_Health
	/// @DnDVersion : 1
	/// @DnDHash : 3FBB663E
	/// @DnDParent : 0632EE7E
	/// @DnDArgument : "health" "min(100,lastHealth+40)"
	
	__dnd_health = real(min(100,lastHealth+40));
}

/// @DnDAction : YoYo Games.Instances.Destroy_Instance
/// @DnDVersion : 1
/// @DnDHash : 2B199E12
instance_destroy();