
/// @func	quack_collision_use_corner();
/// @desc	By default uses vertex corner id. Doesn't work with physics particles.
function quack_collision_use_corner()
{
	var _shader = shader_current();
	var _uniform = shader_get_uniform(_shader, "uniUseCorner");
	shader_set_uniform_i(_uniform, 1);
	shader_enable_corner_id(true);
}

