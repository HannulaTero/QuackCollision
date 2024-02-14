/// @desc GET THE COLLISIONS.
var _quack = quack; // To access in with-blocks


// Add as many instances you want to check collision against.
with(objQuack_Player)
{
	index = _quack.AddInstance(self); 
}


// Check for the collisions.
quack.Begin();
{
	part_system_drawit(particles);
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