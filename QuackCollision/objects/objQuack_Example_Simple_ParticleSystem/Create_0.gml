/// @desc INITIALIZE STRUCTURES.
event_inherited();


// Collider functionality.
quack = new QuackCollisionSimple();


// Particle system.
particles = part_system_create(prtQuack_Example_Simple);
part_system_position(particles, room_width/2, room_height);


// Collision parameters.
radiusPlayer = 32;
radiusParticle = 24;


// Title
title = @"
EXAMPLE
-
SIMPLE PARTICLE SYSTEM COLLISION
-
Instance and particles use radius for collision.
In practice checks whether two points are near enough.
";