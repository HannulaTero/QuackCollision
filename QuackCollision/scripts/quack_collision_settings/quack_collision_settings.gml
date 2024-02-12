#macro	quack_collision global.g_quack_collision

// Quack global datastructure.
quack_collision = {};
quack_collision.previous = [-1];

quack_collision.buffer = {};
quack_collision.buffer.areas = buffer_create(64, buffer_grow, 1);
quack_collision.buffer.result = buffer_create(64, buffer_fixed, 1);

quack_collision.surface = {};
quack_collision.surface.areas = -1;
quack_collision.surface.result = -1;



