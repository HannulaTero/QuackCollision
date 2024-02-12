
/// @func	quack_collision_do(_inst, _func);
/// @desc	Simplified handle to get single instance collision against drawables.
/// @param	{Id.Instance}	_inst
/// @param	{Function}		_func
function quack_collision_do(_inst, _func)
{
	// Temporal to not mess with originals.
	static dsize = buffer_sizeof(buffer_f32);
	static areas = buffer_create(dsize * 4, buffer_grow, 4);
	static result = buffer_create(dsize * 4, buffer_grow, 4);
	
	// Replace data for a while so won't affect those.
	var _areas = quack_collision.buffer;
	var _result = quack_collision.result;
	quack_collision.buffer.areas = areas;
	quack_collision.buffer.result = result;
	
	// Do the calculation.
	var _index= quack_collision_instance(_inst);
	quack_collision_begin();
	_func();
	quack_collision_end();
	var _collided = quack_collision_get(_index);
	
	// Return previous datastructures.
	quack_collision.buffer.areas = _areas;
	quack_collision.buffer.result = _result;
	return _collided;
}
