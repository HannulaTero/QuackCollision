

/// @func	quack_collision_begin();
/// @desc	Changes GPU settings and prepares surface for rendering.
/// @return	{Undefined}
function quack_collision_begin()
{
	// Store previous GPU settings.
	gpu_push_state();
	array_push(quack_collision.previous, shader_current());
	
	// Preparations
	// Might require padding to fit 2x2 blocks for derivatives.
	var _dsize = buffer_sizeof(buffer_f32);
	var _tell = buffer_tell(quack_collision.buffer.areas);
	var _count = floor(_tell / (_dsize * 4));
	var _w = min(_count + 1, 1024);
	var _h = (_count div _w) + 1;
	var _size = _w * _h;
	var _bytes = _size * _dsize * 4;
	
	// Make buffers large enough, otherwise buffer_get/set_surface might not work.
	if (buffer_tell(quack_collision.buffer.areas) < _bytes)
		buffer_resize(quack_collision.buffer.areas, _bytes);
		
	if (buffer_tell(quack_collision.buffer.result) < _bytes)
		buffer_resize(quack_collision.buffer.result, _bytes);

	// Setup the areas surfaces. 
	quack_collision.surface.areas = surface_create(_w, _h, surface_rgba32float);
	buffer_set_surface(quack_collision.buffer.areas, quack_collision.surface.areas, 0);
	
	// Setup the target surface. Following rendering happen here.
	quack_collision.surface.result = surface_create(_w, _h, surface_rgba32float);
	surface_set_target(quack_collision.surface.result);
	draw_clear_alpha(c_black, 0); // Make sure no remnants.
	
	// Setup the GPU settings.
	static shader = shdQuackCollision;
	static camera = camera_create_view(-16384, -16384, +32768, +32768);
	shader_set(shader);
	gpu_set_tex_filter(false);
	gpu_set_tex_repeat(false);
	gpu_set_blendenable(true);
	gpu_set_blendmode_ext(bm_one, bm_one);
	camera_apply(camera);			// To avoid GM automatic culling.
	quack_collision_use_corner();	// By default use corner id's.
	quack_collision_scale();		// By default use full quads.
	quack_collision_offset();		// No offsets for quad size.
	
	// Setup the uniforms.
	static texAreas = shader_get_sampler_index(shader, "texAreas");
	static uniTexel = shader_get_uniform(shader, "uniTexel");
	static uniOutputSize = shader_get_uniform(shader, "uniOutputSize");
	texture_set_stage(texAreas, surface_get_texture(quack_collision.surface.areas));
	shader_set_uniform_f(uniTexel, 1.0 / _w, 1.0 / _h);
	shader_set_uniform_f(uniOutputSize, _w, _h);
}



