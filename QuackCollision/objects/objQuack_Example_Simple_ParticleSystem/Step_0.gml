/// @desc CHANGE MOUSE RADIUS

if (mouse_wheel_down())
	radiusPlayer *= 2;
if (mouse_wheel_up())
	radiusPlayer /= 2;

radiusPlayer = clamp(radiusPlayer, 8, 512);

