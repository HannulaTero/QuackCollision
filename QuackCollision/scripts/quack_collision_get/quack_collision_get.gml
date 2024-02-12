
/// @func	quack_collision_get(_index);
/// @desc	Get how many collided with area of given index. 
/// @param	{Real} _index
function quack_collision_get(_index)
{
	return buffer_peek(quack_collision.buffer.result, _index, buffer_f32);
}

