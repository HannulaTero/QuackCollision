
/// @func	quack_collision_use_coord(_spr, _img);
/// @desc	This is required for physics particles, as the vertex corner id doesn't work with them.
/// @param	{Asset.GMSprite}	_spr
/// @param	{Real}				_img
function quack_collision_use_coord(_spr=undefined, _img=0)
{
	var _shader = shader_current();
	var _uniUseCorner = shader_get_uniform(_shader, "uniUseCorner");
	var _uniCoordMiddle = shader_get_uniform(_shader, "uniCoordMiddle");
	
	shader_set_uniform_i(_uniUseCorner, 0);
	if (_spr == undefined)
	{
		shader_set_uniform_f(_uniCoordMiddle, 0.5, 0.5);
		return;
	} 
	
	var _uvs = sprite_get_uvs(_spr, _img);
	var _x = mean(_uvs[0], _uvs[2]);
	var _y = mean(_uvs[1], _uvs[3]);
	shader_set_uniform_f(_uniCoordMiddle, _x, _y);
}
