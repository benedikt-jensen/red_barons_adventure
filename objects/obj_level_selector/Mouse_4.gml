var _max_unlocked_level = global.highest_unlocked_level[global.difficulty_level];
var _total_levels = 3;
global.start_from_level = (global.start_from_level+1) % (min(_max_unlocked_level+1,_total_levels));

if (global.highest_unlocked_boss[global.difficulty_level] < global.start_from_level) {
	global.start_from_boss = false;
}