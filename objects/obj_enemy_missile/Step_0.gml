speed = 10;

if(target_obj == undefined || !instance_exists(target_obj))
{
	/// Find red baron if exists
	
	target_obj = undefined;
	var _smallest_distance = 10000;
	
	with(obj_red_baron) {
		_dist = point_distance(other.x,other.y,x,y);
		if _dist < _smallest_distance {
			_smallest_distance = _dist;
			other.target_obj = id;
		}
	}
}

if(!(target_obj == undefined))
{
	var l6542349E_0 = false;
	l6542349E_0 = instance_exists(target_obj);
	if(l6542349E_0)
	{
		if (alarm[0] > 0) {
			var _dir = point_direction(x, y, target_obj.x, target_obj.y);
			var _diff_dir = direction - _dir;
		
			if abs(_diff_dir) > 180 {
				var _diff_dir = -360 * sign(_diff_dir) + _diff_dir; 
			}
		
			var steering_speed = 1;
			var _factor = min(steering_speed, abs(_diff_dir))
			direction -= _factor * sign(_diff_dir);
		}
	}
}

image_angle = direction;