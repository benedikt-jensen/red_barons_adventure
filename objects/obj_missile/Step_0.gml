speed = 15;

if(target_obj == undefined || !instance_exists(target_obj))
{
	/// Find closest french aircraft
	
	target_obj = undefined;
	var _smallest_distance = 10000;
	
	with(obj_enemy_parent) {
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
		var _dir = point_direction(x, y, target_obj.x, target_obj.y);
		var _diff_dir = direction - _dir;
		
		if abs(_diff_dir) > 180 {
			var _diff_dir = -360 * sign(_diff_dir) + _diff_dir; 
		}
		
		var _factor = min(6, abs(_diff_dir))
		direction -= _factor * sign(_diff_dir);
	}
}

image_angle = direction;