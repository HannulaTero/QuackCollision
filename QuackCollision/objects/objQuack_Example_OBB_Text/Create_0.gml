/// @desc INITIALIZE STRUCTURES.
event_inherited();


// Collider functionality.
quack = new QuackCollisionOBB();


// Instances.
repeat(128)
{
	var _x = lerp(room_width * 0.1, room_width * 0.9, random(1));
	var _y = lerp(room_height * 0.1, room_height * 0.2, random(1));
	instance_create_depth(_x, _y, 0, objQuack_Thing);
}


// Draw text.
keyboard_string = "";
text = "Type to try!\nHello World!\n";
DrawText = function()
{
	var _x = room_width / 2;
	var _y = room_height / 2;
	var _angle = dsin(current_time/3) * 5;
	draw_set_font(ftQuack_Example);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text_transformed(_x, _y, text, 2, 2, _angle);
};


// Title
title = @"
EXAMPLE
-
OBB TEXT COLLISION
-
Instance collides with written text,
both use Orientated Bounding Boxes.
Type text!
";