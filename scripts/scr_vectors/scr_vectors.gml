// Array-based 2D vector helpers ([x, y]). Used by scr_lighting; for a
// struct-based alternative with more operations see Vec2 in scr_util.

function v_mag(vector2) {
	return sqrt(sqr(abs(vector2[0]))+sqr(abs(vector2[1])))
}

function v_norm(vector2) {
	var mag = v_mag(vector2);
	if  mag==0 {
		return undefined;
	}		
	return [vector2[0]/mag, vector2[1]/mag];
}