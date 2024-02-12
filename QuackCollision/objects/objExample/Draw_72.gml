/// @desc TESTING
/*
var _w = 4;
var _h = 4;
var _surfA = surface_create(_w, _h, surface_rgba32float);
var _surfB = surface_create(_w, _h, surface_rgba32float);
var _surfC = surface_create(_w, _h, surface_rgba32float);
var _surfD = surface_create(_w, _h, surface_rgba32float);

var _x = 128;
var _y = 256;
gpu_push_state();
gpu_set_tex_filter(true);
gpu_set_tex_repeat(true);
gpu_set_blendenable(false);
gpu_set_cullmode(cull_noculling);
surface_set_target_ext(0, _surfA);
surface_set_target_ext(1, _surfB);
surface_set_target_ext(2, _surfC);
surface_set_target_ext(3, _surfD);
camera_apply(camera);
draw_clear_alpha(0, 0);
shader_set(shdTest);
shader_enable_corner_id(true);
var _uniSize = shader_get_uniform(shdTest, "uniSize");
shader_set_uniform_f(_uniSize, _w, _h);
var _sw = sprite_get_width(sprParticle);
var _sh = sprite_get_height(sprParticle);
//draw_sprite_stretched(sprParticle, 0, 0, 0, _sw, _sh);	// Works			In render area
//draw_sprite_stretched(sprParticle, 0, _x, _y, _sw, _sh);	// Works			Outside render area
//draw_sprite(sprParticle, 0, _x, _y);						// Doesn't work		Outside render area
draw_sprite(sprParticle, 0, 0, 0);						// Works			In render area
//draw_sprite(sprParticle, 0, _sw*0.5, _sh*0.5);			// Works			Outside but near render area
//draw_sprite(sprParticle, 0, _sw*0.75, _sh*0.75);			// Works			Outside but near render area
//draw_sprite(sprParticle, 0, _sw*1.0, _sh*1.0);			// Doesn't work		Outside render area
//part_system_drawit(particlesOneBuiltin);					// Works			Outside render area
//part_system_drawit(particlesOneCustom);					// Doesn't work		Outside render area
//physics_particle_draw(flags, 0, sprParticle, 0);
//physics_particle_draw_ext(flags, 0, sprParticle, 0, 1, 1, 0, c_white, 1);

shader_enable_corner_id(false);
shader_reset();
surface_reset_target();
gpu_pop_state();


var _buff = buffer_create(_w * _h * 4 * 4, buffer_fixed, 1);
buffer_get_surface(_buff, _surfA, 0);
buffer_get_surface(_buff, _surfB, 0);
buffer_get_surface(_buff, _surfC, 0);
buffer_get_surface(_buff, _surfD, 0);


buffer_delete(_buff);
surface_free(_surfA);
surface_free(_surfB);
surface_free(_surfC);
surface_free(_surfD);



















































