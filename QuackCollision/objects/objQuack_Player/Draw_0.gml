/// @desc DRAW SELF, RESET THE DEFAULT.

image_blend = (collisions > 0) ? c_red : c_white;
image_index = (collisions > 0) ? 1 : 0;
draw_self();
