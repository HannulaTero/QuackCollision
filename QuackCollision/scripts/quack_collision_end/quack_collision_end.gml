/// @func	quack_collision_end(_reset);
/// @desc	Returns the result of computation, and restores previous GPU settings.
/// @param	{Bool}	_reset		Whether area index is zeroed. Buffer size stays cached.
function quack_collision_end(_reset=true)
{
	// Return previous settings.
	var _previous = array_pop(quack_collision.previous);
	if (_previous != -1)
		shader_set(_previous);
	else 
		shader_reset();
	shader_enable_corner_id(false);
	gpu_pop_state();
	surface_reset_target();
	
	// Get the results to buffer.
	buffer_get_surface(quack_collision.buffer.result, quack_collision.surface.result, 0);
	buffer_seek(quack_collision.buffer.result, buffer_seek_start, 0);
	surface_free(quack_collision.surface.result);
	
	// Reset areas surface, and reset buffer.
	surface_free(quack_collision.surface.areas);
	if (_reset == true)
	{
		buffer_seek(quack_collision.buffer.areas, buffer_seek_start, 0);
	}
	
	// Return the result.
	buffer_seek(quack_collision.buffer.result, buffer_seek_start, 0);
	return quack_collision.buffer.result;
}