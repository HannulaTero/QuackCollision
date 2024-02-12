
/// @func	quack_collision_offset(_xmin, _ymin, _xmax, _ymax);
/// @desc	Offsets size of particles' collider area. 
/// @param	{Real} _xmin
/// @param	{Real} _ymin
/// @param	{Real} _xmax
/// @param	{Real} _ymax
/// @return	{Undefined}
function quack_collision_offset(_xmin=0, _ymin=0, _xmax=0, _ymax=0)
{
	var _shader = shader_current();
	var _uniform = shader_get_uniform(_shader, "uniQuadOffset");
	shader_set_uniform_f(_uniform, _xmin, _ymin, _xmax, _ymax);
}

