/// @desc DRAW SELF, RESET THE DEFAULT.

var _c = make_color_hsv(0, 64, 255)
image_blend = (collisions > 0) ? _c : c_white;
image_index = (collisions > 0) ? 1 : 0;
draw_self();
