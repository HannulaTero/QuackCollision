/// @desc GET THE COLLISIONS.
var _quack = quack; // To access in with-blocks


// Add as many instances you want to check collision against.
// Access collision information later you need to use the index from method.
with(objQuack_Player)
{
	index = _quack.AddInstanceAngled(self);
}


// Do the collision check.
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