/// @desc FREE STRUCTURES.

quack.Free(); 
part_system_destroy(particles);
physics_particle_delete_region_box(0, 0, room_width, room_height);
instance_destroy(objQuack_Thing);