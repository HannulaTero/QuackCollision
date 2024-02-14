/// @desc DRAW INFO
if (!infoDraw)
	exit;

var _w = display_get_gui_width();
var _h = display_get_gui_height();

// Draw example list.
draw_set_font(ftQuack_Example);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(16, 16, @"
QUACK COLLISION

Collisions with drawn quads, such as particle system, 
which normally don't have any way to collide with.
Examples demonstrate collisions, movement is extra. 

Press ENTER) To hide/unhide debug overlay.
Press SPACE) To hide/unhide texts.
Press TAB) Draw colliders.
Press DEL) Remove all thingies.

Press 1) ParticleSystem Simple.
Press 2) ParticleSystem AABB.
Press 3) ParticleSystem OBB.
Press 4) Miscellenous OBB.
Press R) Remove example.
");


// Draw controls.
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_text(16, _h - 16, @"
Mouse Control.

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
	draw_text(_w - 16, 16, $"\nPlayer Instance\nCollisions  : {collisions}\nChecks Done : {total}");
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

