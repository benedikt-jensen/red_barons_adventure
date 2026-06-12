global.formations = ds_map_create();
global.formations[? "V3"] = new_v_formation(3);
global.formations[? "V4"] = new_v_formation(4);
global.formations[? "V5"] = new_v_formation(5);
global.formations[? "V6"] = new_v_formation(6);
global.formations[? "V7"] = new_v_formation(7);
global.formations[? "V8"] = new_v_formation(8);
global.formations[? "V9"] = new_v_formation(9);

function Formation(_pos_arr=[], _time_arr=[]) constructor {
	y_arr = _pos_arr;
	time_arr =_time_arr;
	function add(_pos, _time) {
		array_push(y_arr,_pos);
		array_push(time_arr,_time);
	}
}

function new_v_formation(_n) {
	var _res = new Formation();
	var _is_even = (_n % 2 == 0);
	var _cols = ceil(_n / 2);
	var _min_y = 0;
	var _max_y = 1;
	var _center_y = 0.5;
	if _max_y < _min_y {
		show_debug_message("error: bottom > top!");
		return;
	}
	var _time_spacing = 1 / (_cols-1);
	var _y_spacing = _n==1 ? 0 : (_max_y-_min_y) / (_n-1);
	var _y_offset = 0;
	if _is_even {
		_y_offset = _y_spacing / 2;
	}
	
	var _spawned_count = 0;
	var _col = 0;
	while (_spawned_count < _n) {
		if !_is_even && _spawned_count==0 {
			array_push(_res.y_arr, _center_y);
			array_push(_res.time_arr, _col * _time_spacing);
			_spawned_count++;
		} else {
			// push pos and time
			for (var _sign = -1; _sign<=1; _sign+=2){
				array_push(_res.y_arr, _center_y + _sign * _y_offset);
				array_push(_res.time_arr, _col * _time_spacing);
				_spawned_count++;
			}
		}
		_y_offset += _y_spacing;
		_col += 1;
	}
	return _res;
}

function spawn_formation(_formation, _enemy_obj, _enemy_speed, _bottom, _top, 
	_vertical_padding, _duration, _mirror=false){
	var _min_y = _top+_vertical_padding;
	var _h = (_bottom-_vertical_padding) -_min_y;
	for (var _i = 0; _i<array_length(_formation.y_arr); _i++) {
		var _y = _min_y + _formation.y_arr[_i] * _h;
		var _time = (_mirror ? 1-_formation.time_arr[_i] : _formation.time_arr[_i]) * _duration;
		var _argv = [_enemy_obj,_y,_enemy_speed];
		exec_delayed(spawn_at_y_with_speed,	_argv, _time);
	}
}

function spawn_formation_centered(_formation, _enemy_obj, _duration,
	_vertical_padding, _mirror=false) {
	spawn_formation(_formation, _enemy_obj, 5,
		global.y_limit, 0, _vertical_padding, _duration, _mirror);
}

