/// @desc MOVEMENT
if (device_mouse_check_button(0, mb_left))
{
	moveX += clamp(mouse_x - x, -4, 4);
	moveY += clamp(mouse_y - y, -4, 4);
}

x += moveX + hspeed;
y += moveY + vspeed;

hspeed += moveX * 0.25;
vspeed += moveY * 0.25 + 0.5;

moveX = 0;
moveY = 0;
