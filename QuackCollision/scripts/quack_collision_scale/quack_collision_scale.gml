
/// @func	quack_collision_scale(_xscale, _yscale);
/// @desc	Tries automatically use drawn sprites full quad as collision area. 
/// @param	{Real} _xscale
/// @param	{Real} _yscale
function quack_collision_scale(_xscale=1, _yscale=1)
{
	var _shader = shader_current();
	var _uniform = shader_get_uniform(_shader, "uniQuadScale");
	shader_set_uniform_f(_uniform, _xscale, _yscale, _xscale, _yscale);
}

