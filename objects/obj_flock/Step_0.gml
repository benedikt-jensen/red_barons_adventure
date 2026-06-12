members = array_filter(members, function(_m) { return instance_exists(_m); });

// Ease toward decided altitude/pace so slot targets never jump; formation
// morphs blend over ~2 seconds
base_y = lerp(base_y, target_base_y, 0.02);
flight_speed = lerp(flight_speed, target_speed, 0.02);
morph_t = min(morph_t + 1/120, 1);

center_x -= flight_speed / distance;

// "Decisions" debug slider scales how often the flock changes its mind
// (0 = never)
decision_timer -= global.bird_decision_mult;
if (decision_timer <= 0) {
	make_decision();
}

// -600 so even the trailing slots are fully off screen before the brain
// (and with it the members' steering target) disappears
if (center_x < -600 || array_length(members) == 0) {
	instance_destroy();
}
