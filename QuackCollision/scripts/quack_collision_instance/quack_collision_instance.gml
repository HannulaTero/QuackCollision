

/// @func	quack_collision_instance(_inst);
/// @desc	Add new instance to check against with its bounding box.
/// @param	{Id.Instance} _inst
/// @return	{Real}
function quack_collision_instance(_inst)
{
	return quack_collision_area(
		_inst.bbox_left, _inst.bbox_top, 
		_inst.bbox_right, _inst.bbox_bottom
	);
}
