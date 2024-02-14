/// @desc GET THE COLLISIONS.
var _quack = quack;


// Set player as collision area.
with(objQuack_Player)
{
	_quack.AddInstance(self);
}

// Do the collision detection.
quack.Begin();
{
	// Collide with particle system.
	quack.SetRadius(radiusParticle);
	part_system_drawit(particles);
}
quack.End();

// If there was a collision.
with(objQuack_Player)
{
	collisions = _quack.GetCollisions();
	moveX = _quack.GetX();
	moveY = _quack.GetY();
	total = _quack.GetTotal();
}