/// @desc DRAW INFO
var _w = display_get_gui_width();
var _h = display_get_gui_height();

// Draw example list.
draw_set_font(ftQuack_Example);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(16, 16, @"
QUACK COLLISION
Collisions with drawn quads, such as particle system particles.
    Press 1)   Simple collision.
    Press 2)   AABB collision.
    Press 3)   OBB collision.
    Press DEL) Remove example.
");


// Draw controls.
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_text(16, _h - 16, @"
Mouse to Control.
    Press LEFT)  Move character.
    Press RIGHT) Rotate character.
    Press WHEEL) Randomize size.
   Scroll WHEEL) Change size.
");


// Draw collision information.
with(objQuack_Player)
{
	draw_set_halign(fa_right);
	draw_set_valign(fa_top);
	draw_text(_w - 16, 16, $"\nCollisions  : {collisions}\nChecks Done : {total}");
}

// Draw current example information.
with(parQuack_Example)
{
	// Draw the example title
	draw_set_halign(fa_right);
	draw_set_valign(fa_bottom);
	draw_text(_w - 16, _h - 16, title);
	
	// Draw collision information.
	draw_set_halign(fa_right);
	draw_set_valign(fa_top);
	// draw_text(_w - 16, 16, $"Collisions : {collisions}\nChecks : {total}");
}

