/// @desc CREATE PARTICLES
repeat(2048)
{
	instance_create_depth(random(room_width), random(room_height), 0, objCollider);
}
squeak = new SqueakCollision();
quack = new QuackCollision();
repeats = 0;

x = 128;
y = 256;
image_xscale = 0.5;
image_yscale = 0.5;
index = -1;
show_debug_overlay(true, true);
particlesSmoke = part_system_create(prtSmoke);
particlesOther = part_system_create(prtOther);
//particlesOneBuiltin = part_system_create(prtOneBuiltin);
//particlesOneCustom = part_system_create(prtOneCustom);
part_system_position(particlesSmoke, room_width/2, room_height*2/3);
part_system_position(particlesOther, room_width/2, room_height/2);
//part_system_position(particlesOneBuiltin, x, y);
//part_system_position(particlesOneCustom, x, y);

// feather ignore GM1044
flags = phy_particle_flag_water | phy_particle_flag_viscous | phy_particle_flag_tensile;
var _x = (room_width / 2 + 256);
var _y = (room_height / 2);
physics_world_create(1.0);
physics_world_gravity(0.0, 0.0);
physics = physics_particle_create(flags, _x, _y, 0, 0, c_white, 1, 0);


camera = camera_create_view(-16384, -16384, 32768, 32768);


