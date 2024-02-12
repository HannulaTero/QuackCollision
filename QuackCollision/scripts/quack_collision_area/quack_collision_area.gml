
/// @func	quack_collision_area(_xmin, _ymin, _xmax, _ymax);
/// @desc	Add new area to check against. Arguments as absolute values.
/// @param	{Real} _xmin
/// @param	{Real} _ymin
/// @param	{Real} _xmax
/// @param	{Real} _ymax
/// @return	{Real}
function quack_collision_area(_xmin, _ymin, _xmax, _ymax)
{
	var _buff = quack_collision.buffer.areas;
	var _tell = buffer_tell(_buff);
	buffer_write(_buff, buffer_f32, _xmin);
	buffer_write(_buff, buffer_f32, _ymin);
	buffer_write(_buff, buffer_f32, _xmax);
	buffer_write(_buff, buffer_f32, _ymax);
	return _tell;
}