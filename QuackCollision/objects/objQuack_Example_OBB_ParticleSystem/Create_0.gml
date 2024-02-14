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


// Particle system.
particles = part_system_create(prtQuack_Example_OBB);
part_system_position(particles, room_width/2, room_height);


// Title
title = @"
EXAMPLE
-
OBB PARTICLE SYSTEM COLLISION
-
Instance collides with particle system particles,
both use Orientated Bounding Boxes.
";