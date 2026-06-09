/// @description Handle slider drag and close button

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var pressed = mouse_check_button_pressed(mb_left);
var released = mouse_check_button_released(mb_left);

if released dragging = -1;

if pressed {
    if abs(mx - close_cx) < close_hw && abs(my - close_cy) < close_hh {
        instance_destroy();
        exit;
    }
    for (var i = 0; i < 3; i++) {
        var ty = track_y[i];
        if mx >= track_x - thumb_r && mx <= track_x + track_w + thumb_r
                && my >= ty - thumb_r * 2 && my <= ty + thumb_r * 2 {
            dragging = i;
        }
    }
}

if dragging >= 0 {
    var val = clamp((mx - track_x) / track_w, 0, 1);
    switch dragging {
        case 0: global.master_volume = val; break;
        case 1: global.music_volume = val; break;
        case 2: global.sfx_volume = val; break;
    }
    apply_audio_settings();
}
