/// @desc INITIALIZE STRUCTURES.
event_inherited();

// Collider functionality.
quack = new QuackCollisionAABB();

// Particle system.
particles = part_system_create(prtQuack_Example_AABB);
part_system_position(particles, room_width/2, room_height);

// Title
title = @"
EXAMPLE
-
AABB PARTICLE SYSTEM COLLISION
-
Axis-Aligned Bounding Box.
";