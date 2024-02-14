/// @desc MOVEMENT, SIZE, ANGLE.

// Control the player.
if (device_mouse_check_button(0, mb_left))
{
	x = mouse_x;
	y = mouse_y;
}


// Change angle.
if (device_mouse_check_button(0, mb_right))
{
	image_angle += 6;
}


// Change the size.
if (mouse_wheel_down())
{
	image_xscale += 0.125;
	image_yscale += 0.125;
}

if (mouse_wheel_up())
{
	image_xscale -= 0.125;
	image_yscale -= 0.125;
}

if (device_mouse_check_button(0, mb_middle))
{
	image_xscale = random_range(0.125, 2);
	image_yscale = random_range(0.125, 2);
}

image_xscale = clamp(image_xscale, 0.125, 2);
image_yscale = clamp(image_yscale, 0.125, 2);

