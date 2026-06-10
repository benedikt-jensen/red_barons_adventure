global.spawn_env_obj_counter = 0;

function spawn_env_objects() {
    global.spawn_env_obj_counter += global.env_speed;

    while (global.spawn_env_obj_counter > 0) {
        
        global.spawn_env_obj_counter -= 1;

        if(room==room_grasslands)
        {
            /// @DnDAction : YoYo Games.Common.If_Variable
            /// @DnDVersion : 1
            /// @DnDHash : 4FA92BB5
            /// @DnDParent : 383431D7
            /// @DnDArgument : "var" "random(10)"
            /// @DnDArgument : "op" "1"
            /// @DnDArgument : "value" "1"
            if(random(100) < global.plant_spawn_mult)
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
            if(random(100) < global.tree_spawn_mult)
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
            if(random(100) < global.rock_spawn_mult)
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
    }

}