play_sfx(snd_splash, 0, 0);

depth = layer_get_depth(layer_get_id("Instances")) - 10;

image_blend = $CCFFCCCC & $ffffff;
image_alpha = ($CCFFCCCC >> 24) / $ff;