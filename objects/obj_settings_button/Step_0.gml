/// @description Handle click

hovered = abs(mouse_x - x) < btn_hw && abs(mouse_y - y) < btn_hh;

if hovered && mouse_check_button_released(mb_left) && global.GUI.is_enabled() {
    if !instance_exists(obj_settings_panel) {
        instance_create_layer(0, 0, "part_foreground", obj_settings_panel);
    }
}
