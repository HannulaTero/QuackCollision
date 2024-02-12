

/// @func	QuackCollisionOBB();
/// @desc	Do the collision with drawn quads as Oriented Bounding Boxes.
function QuackCollisionOBB() constructor
{
//==========================================================
//
#region INSTANCE VARIABLE DECLARATION.


	self.surface = {}; 
	self.surface.areas = -1;
	self.surface.angle = -1;
	self.surface.result = -1;
	
	self.buffer = {};
	self.buffer.areas = buffer_create(64, buffer_grow, 1);
	self.buffer.angle = buffer_create(64, buffer_grow, 1);
	self.buffer.result = buffer_create(64, buffer_grow, 1);
	
	
#endregion
// 
//==========================================================
//
#region STATIC VARIABLE DECLARATION.


	// Previous stores previous shaders to return them back after computation.
	// Camera is needed to avoid GM automatic culling. 
	static previous = [-1]; 
	static camera = camera_create_view(-16384, -16384, +32768, +32768);
	static shader = shdQuackCollisionOBB;
	static format = surface_rgba32float;
	static dtype = buffer_f32;
	static dsize = buffer_sizeof(dtype);

	
#endregion
// 
//==========================================================
//
#region SHADER UNIFORMS.


	static uniUseCorner = shader_get_uniform(shader, "uniUseCorner");
	static uniCoordMiddle = shader_get_uniform(shader, "uniCoordMiddle");
	static texA = shader_get_sampler_index(shader, "texA");
	static texB = shader_get_sampler_index(shader, "texB");
	static uniTexel = shader_get_uniform(shader, "uniTexel");
	static uniSize = shader_get_uniform(shader, "uniSize");
	static uniScale = shader_get_uniform(shader, "uniScale");


#endregion
// 
//==========================================================
//
#region USER HANDLES: ADD COLLIDERS 

	
	// Add collision area.
	static AddArea = function(_x, _y, _w, _h, _rot)
	{
		var _areas = self.buffer.areas;
		var _index = buffer_tell(_areas);
		buffer_write(_areas, dtype, _x - _w * 0.5);
		buffer_write(_areas, dtype, _y - _h * 0.5);
		buffer_write(_areas, dtype, _x + _w * 0.5);
		buffer_write(_areas, dtype, _y + _h * 0.5);
		return _index;
	};
	
	
	// Add collision area with instance.
	static AddInstance = function(_inst)
	{
		
		return AddArea(
			_inst.bbox_left, _inst.bbox_top, 
			_inst.bbox_right, _inst.bbox_bottom,
			_inst.image_angle
		);	
	};


#endregion
// 
//==========================================================
//
#region USER HANDLES: BEGIN COMPUTATION.

	
	// Start checking for collision with given position.
	static Begin = function()
	{
		// Store previous GPU settings.
		gpu_push_state();
		array_push(previous, shader_current());
		
		// Preparations.
		// Might require padding, as derivatives are done in 2x2 blocks.
		var _tell = buffer_tell(self.buffer.areas);
		var _count = floor(_tell / (dsize * 4));
		var _w = min(_count + 1, 1024);
		var _h = (_count div _w) + 1;
		var _size = _w * _h;
		var _bytes = _size * dsize * 4;
		
		// Make buffers large enough, otherwise buffer_get/set_surface might not work.
		if (buffer_tell(self.buffer.areas) < _bytes)
			buffer_resize(self.buffer.areas, _bytes);
		
		if (buffer_tell(self.buffer.result) < _bytes)
			buffer_resize(self.buffer.result, _bytes);
			
		// Setup the areas to be a sampler.
		self.surface.areas = VerifySurface(self.surface.areas, _w, _h);
		buffer_set_surface(self.buffer.areas, self.surface.areas, 0);
	
		// Setup the target surface. Following rendering happen here.
		self.surface.result = VerifySurface(self.surface.result, _w, _h);
		surface_set_target(self.surface.result);
		draw_clear_alpha(c_black, 0); // Make sure no remnants.
	
		// Setup the GPU settings.
		shader_set(shader);
		gpu_set_tex_filter(false);
		gpu_set_tex_repeat(false);
		gpu_set_blendenable(true);
		gpu_set_blendmode_ext(bm_one, bm_one);
		camera_apply(camera); // To avoid GM automatic culling.
		UseCorner(); // By default use corner id's.
		SetScale(); // By default full quads.
	
		// Setup the other uniforms.
		var _texture = surface_get_texture(self.surface.areas)
		texture_set_stage(texA, _texture);
		shader_set_uniform_f(uniTexel, 1.0 / _w, 1.0 / _h);
		shader_set_uniform_f(uniSize, _w, _h);
		return self;
	};
	

#endregion
// 
//==========================================================
//
#region USER HANDLES: SET PARAMETERS.

	
	// Set quad offset for collider area.
	static SetScale = function(_scale=1)
	{
		shader_set_uniform_f(uniScale, _scale);
		return self;
	};
	
	
	// This is required for physics particles, as vertex corner id doesn't work.
	static UseCoord = function(_spr=undefined, _img=0)
	{
		shader_set_uniform_i(uniUseCorner, 0);
		var _x = 0.5;
		var _y = 0.5;
		if (_spr != undefined)
		{
			var _uvs = sprite_get_uvs(_spr, _img);
			_x = mean(_uvs[0], _uvs[2]);
			_y = mean(_uvs[1], _uvs[3]);
		}
		shader_set_uniform_f(uniCoordMiddle, _x, _y);
		return self;
	};
	
	
	// To return using vertex corner id after UseCoord.
	static UseCorner = function()
	{
		shader_set_uniform_i(uniUseCorner, 1);
		shader_enable_corner_id(true);
		return self;	
	};
	
	
#endregion
// 
//==========================================================
//
#region USER HANDLES: END COMPUTATION.


	// Ends the calculations and return s previous GPU settings.
	static End = function(_resetAreas=true)
	{
		// Return previous settings.
		var _previous = array_pop(previous);
		if (_previous != -1)
			shader_set(_previous);
		else 
			shader_reset();
		shader_enable_corner_id(false);
		gpu_pop_state();
		surface_reset_target();
	
		// Get the results to buffer.
		buffer_get_surface(self.buffer.result, self.surface.result, 0);
		buffer_seek(self.buffer.result, buffer_seek_start, 0);
	
		// Reset areas, next time have to set up them again.
		if (_resetAreas == true)
			buffer_seek(self.buffer.areas, buffer_seek_start, 0);
	
		// Return the result.
		buffer_seek(self.buffer.result, buffer_seek_start, 0);
		return self.buffer.result;
	};
	
	
#endregion
// 
//==========================================================
//
#region USER HANDLES: GET RESULTS


	// Get collision result from results.
	static Get = function(_index)
	{
		return buffer_peek(self.buffer.result, _index, dtype);	
	};
	

#endregion
// 
//==========================================================
//
#region VERIFY SURFACE.


	// Verify surface existance and dimensions.
	static VerifySurface = function(_surface, _w, _h)
	{
		// Verify correctness.
		if (surface_exists(_surface))
		{
			// Force recreation if not correct.
			if (surface_get_width(_surface) != _w)
			|| (surface_get_height(_surface) != _h)
			{
				surface_free(_surface);
			}
		}
		
		// Create surface if necessary.
		if (!surface_exists(_surface))
		{
			_surface = surface_create(_w, _h, surface_rgba32float);
		}
		
		return _surface;
	};


#endregion
// 
//==========================================================
//
#region USER HANDLES: FREE OR RESET DATASTRUCTURES.


	// Resets buffer sizes.
	static ResetBuffer = function()
	{
		buffer_resize(self.buffer.areas, 64);
		buffer_resize(self.buffer.result, 64);
		buffer_seek(self.buffer.areas, buffer_seek_start, 0);
		return self;
	};
	
	
	// Free the datastructures.
	static Free = function()
	{
		if (surface_exists(self.surface.areas))
			surface_free(self.surface.areas);
			
		if (surface_exists(self.surface.result))
			surface_free(self.surface.result);
		
		if (buffer_exists(self.buffer.areas))
			buffer_delete(self.buffer.areas);
		
		if (buffer_exists(self.buffer.result))
			buffer_delete(self.buffer.result);
		
		return self;
	};
	
	
#endregion
// 
//==========================================================
}






