/// @desc INITIALIZE STRUCTURES.
event_inherited();

// Collider functionality.
quack = new QuackCollisionOBB();

// Particle system.
particles = part_system_create(prtQuack_Example_OBB);
part_system_position(particles, room_width/2, room_height);

// Title
title = @"
EXAMPLE
-
OBB PARTICLE SYSTEM COLLISION
-
Oriented Bounding Box.
";