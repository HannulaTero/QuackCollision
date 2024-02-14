/// @desc GET THE COLLISIONS.
var _quack = quack; // To access in with-blocks


// Add as many instances you want to check collision against.
with(objQuack_Player)
{
	index = _quack.AddInstance(self); 
}
	
with(objQuack_Thing)
{
	index = _quack.AddInstance(self); 
}


// Check for the collisions.
quack.Begin();
{
	// Collide with particle system.
	part_system_drawit(particles);
	
	// To constrain play area.
	quack.UseCoord(sprQuack_Example_Wall, 0);
	draw_sprite_stretched(sprQuack_Example_Wall, 0, 0, room_height, room_width, 64);
	draw_sprite_stretched(sprQuack_Example_Wall, 0, 0, -room_height, 64, room_height * 2);
	draw_sprite_stretched(sprQuack_Example_Wall, 0, room_width, -room_height, 64, room_height * 2);
}
quack.End();


// Get the collision results.
with(objQuack_Player)
{
	collisions = _quack.GetCollisions(index);
	moveX = _quack.GetX(index);
	moveY = _quack.GetY(index);
	total = _quack.GetTotal(index);
}

with(objQuack_Thing)
{
	collisions = _quack.GetCollisions(index);
	moveX = _quack.GetX(index);
	moveY = _quack.GetY(index);
	total = _quack.GetTotal(index);
}