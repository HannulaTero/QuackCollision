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
particles = part_system_create(prtQuack_Example_OBB2);
part_system_position(particles, room_width/2, room_height);


// Physics particles.
physicsFlag = phy_particle_flag_water;
physics_particle_set_radius(12);
repeat(1024)
{
	var _x = random(room_width);
	var _y = lerp(room_height * 0.3, room_height * 0.9, random(1));
	var _hspd = random_range(-2, 2);
	var _vspd = random_range(-2, 2);
	var _index = physics_particle_create(physicsFlag, _x, _y, _hspd, _vspd, c_white, 1, 0);
}


// Drawing sprites function.
DrawExt = function(_spr, _img)
{
	draw_sprite_ext(_spr, _img, 256, 256, 8.0, 1.0, +current_time / 10, c_white, 1);
	draw_sprite_ext(_spr, _img, 980, 600, 2.5, 3.5, -current_time / 17, c_white, 1);	
	draw_sprite(sprQuack_Example_Wall, 0, 640, 256);
	draw_sprite_ext(sprQuack_Example_Wall, 0, 640 + 128, 256, 2, 1, 45, c_white, 1);
	draw_sprite_stretched(sprQuack_Example_Wall, 0, 640 + 256, 256, 64, 64);
};


// Drawing a text function
DrawText = function()
{
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	var _x = (current_time / 10) mod room_width
	var _y = room_height / 2;
	draw_text_transformed(_x, _y, "HELLO WORLD!", 2, 2, current_time / 33);
};


// Title
title = @"
EXAMPLE
-
OBB MISCELLENOUS COLLISION
-
Instances collide with various drawn things.
There are rotating sprites, physics particles 
and particle system.
";