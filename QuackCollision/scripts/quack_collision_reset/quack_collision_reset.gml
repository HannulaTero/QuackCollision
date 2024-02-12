
/// @func	quack_collision_reset();
/// @desc	Sets buffer sizes to default starting position. 
function quack_collision_reset()
{
	buffer_resize(quack_collision.buffer.areas, 64);
	buffer_resize(quack_collision.buffer.result, 64);
	buffer_seek(quack_collision.buffer.areas, buffer_seek_start, 0);
}

