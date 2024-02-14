

/// @func	QuackCollisionOBB();
/// @desc	Do the collision with drawn quads as Oriented Bounding Boxes.
function QuackCollisionOBB() constructor
{
//==========================================================
//
#region INSTANCE VARIABLE DECLARATION.


	self.surface = {}; 
	self.surface.A = -1;
	self.surface.B = -1;
	self.surface.result = -1;
	
	self.buffer = {};
	self.buffer.A = buffer_create(64, buffer_grow, 1);
	self.buffer.B = buffer_create(64, buffer_grow, 1);
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
	static AddArea = function(_x00, _y00, _x10, _y10, _x01, _y01, _x11, _y11)
	{
		gml_pragma("forceinline");
		var _buffA = self.buffer.A;
		var _buffB = self.buffer.B;
		var _index = buffer_tell(_buffA);
		buffer_write(_buffA, buffer_f32, _x00);
		buffer_write(_buffA, buffer_f32, _y00);
		buffer_write(_buffA, buffer_f32, _x10);
		buffer_write(_buffA, buffer_f32, _y10);
		buffer_write(_buffB, buffer_f32, _x01);
		buffer_write(_buffB, buffer_f32, _y01);
		buffer_write(_buffB, buffer_f32, _x11);
		buffer_write(_buffB, buffer_f32, _y11);
		return _index;
	};
	
	
	// Add collision area with instance
	static AddInstance = function(_inst)
	{
		gml_pragma("forceinline");
		var _buffA = self.buffer.A;
		var _buffB = self.buffer.B;
		var _index = buffer_tell(_buffA);
		with(_inst)
		{
			buffer_write(_buffA, buffer_f32, bbox_left);
			buffer_write(_buffA, buffer_f32, bbox_top);
			buffer_write(_buffA, buffer_f32, bbox_right);
			buffer_write(_buffA, buffer_f32, bbox_top);
			buffer_write(_buffB, buffer_f32, bbox_left);
			buffer_write(_buffB, buffer_f32, bbox_bottom);
			buffer_write(_buffB, buffer_f32, bbox_right);
			buffer_write(_buffB, buffer_f32, bbox_bottom);
		}
		return _index;
	};
	
	
	// Add orientated collision area with instance.
	static AddInstanceAngled = function(_inst)
	{
		gml_pragma("forceinline");
		var _buffA = self.buffer.A;
		var _buffB = self.buffer.B;
		var _index = buffer_tell(_buffA);
		with(_inst)
		{
			var _sin = +dsin(image_angle);
			var _cos = +dcos(image_angle);
			var _xoffset = sprite_get_xoffset(sprite_index);
			var _yoffset = sprite_get_yoffset(sprite_index);
			var _w0 = -image_xscale * (_xoffset - sprite_get_bbox_left(sprite_index));
			var _h0 = -image_yscale * (_yoffset - sprite_get_bbox_top(sprite_index));
			var _w1 = -image_xscale * (_xoffset - sprite_get_bbox_right(sprite_index));
			var _h1 = -image_yscale * (_yoffset - sprite_get_bbox_bottom(sprite_index));
			buffer_write(_buffA, buffer_f32, x + _cos * _w0 + _sin * _h0);
			buffer_write(_buffA, buffer_f32, y - _sin * _w0 + _cos * _h0);
			buffer_write(_buffA, buffer_f32, x + _cos * _w1 + _sin * _h0);
			buffer_write(_buffA, buffer_f32, y - _sin * _w1 + _cos * _h0);
			buffer_write(_buffB, buffer_f32, x + _cos * _w0 + _sin * _h1);
			buffer_write(_buffB, buffer_f32, y - _sin * _w0 + _cos * _h1);
			buffer_write(_buffB, buffer_f32, x + _cos * _w1 + _sin * _h1);
			buffer_write(_buffB, buffer_f32, y - _sin * _w1 + _cos * _h1);
		}
		return _index;
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
		var _dsize = buffer_sizeof(buffer_f32);
		var _tell = buffer_tell(self.buffer.A);
		var _count = floor(_tell / (_dsize * 4));
		var _w = min(_count + 1, 1024);
		var _h = (_count div _w) + 1;
		var _size = _w * _h;
		var _bytes = _size * _dsize * 4;
		
		// Make buffers large enough, otherwise buffer_get/set_surface might not work.
		if (buffer_tell(self.buffer.A) < _bytes)
			buffer_resize(self.buffer.A, _bytes);

		if (buffer_tell(self.buffer.B) < _bytes)
			buffer_resize(self.buffer.B, _bytes);
		
		if (buffer_tell(self.buffer.result) < _bytes)
			buffer_resize(self.buffer.result, _bytes);
			
		// Setup the corner positions to be a samplers.
		self.surface.A = VerifySurface(self.surface.A, _w, _h);
		self.surface.B = VerifySurface(self.surface.B, _w, _h);
		buffer_set_surface(self.buffer.A, self.surface.A, 0);
		buffer_set_surface(self.buffer.B, self.surface.B, 0);
	
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
		var _texA = surface_get_texture(self.surface.A)
		var _texB = surface_get_texture(self.surface.B)
		texture_set_stage(texA, _texA);
		texture_set_stage(texB, _texB);
		shader_set_uniform_f(uniTexel, 1.0 / _w, 1.0 / _h);
		shader_set_uniform_f(uniSize, _w, _h);
		return self;
	};
	

#endregion
// 
//==========================================================
//
#region USER HANDLES: SET PARAMETERS.

	
	// Change quad collider area size.
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
	static End = function(_resetCorners=true)
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
	
		// Reset quad corner positions, next time have to set up them again.
		if (_resetCorners == true)
		{
			buffer_seek(self.buffer.A, buffer_seek_start, 0);
			buffer_seek(self.buffer.B, buffer_seek_start, 0);
		}
	
		// Return the result.
		buffer_seek(self.buffer.result, buffer_seek_start, 0);
		return self.buffer.result;
	};
	
	
#endregion
// 
//==========================================================
//
#region USER HANDLES: GET RESULTS


	// Get the count how many has collided.
	static GetCollisions = function(_index)
	{
		gml_pragma("forceinline");
		return buffer_peek(self.buffer.result, _index, buffer_f32);	
	};
	
	
	// Read minimum translation vector components.
	static GetX = function(_index)
	{
		gml_pragma("forceinline");
		return buffer_peek(self.buffer.result, _index + dsize * 1, buffer_f32);
	};
	
	
	static GetY = function(_index)
	{
		gml_pragma("forceinline");
		return buffer_peek(self.buffer.result, _index + dsize * 2, buffer_f32);
	};
	
	
	// Get total count of collision checks.
	static GetTotal = function(_index)
	{
		gml_pragma("forceinline");
		return buffer_peek(self.buffer.result, _index + dsize * 3, buffer_f32);
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
#region USER HANDLES: DEBUG DRAW.


	// Render collision areas.
	static DebugDraw = function()
	{
		// Store seek position and cache buffer indexes.
		var _buffA = self.buffer.A;
		var _sizeA = buffer_get_size(_buffA);
		var _tellA = buffer_tell(_buffA);
		var _buffB = self.buffer.B;
		var _sizeB = buffer_get_size(_buffB);
		var _tellB = buffer_tell(_buffB);
		var _buffResult = self.buffer.result;
		var _sizeResult = buffer_get_size(_buffResult);
		var _tellResult = buffer_tell(_buffResult);
		var _jumpResult = 3 * buffer_sizeof(buffer_f32);
		
		// Draw all collider areas.
		while(buffer_tell(_buffA) < _sizeA)
		{
			var _collisions = buffer_read(_buffResult, buffer_f32);
			buffer_seek(_buffResult, buffer_seek_relative, _jumpResult);
			var _x00 = buffer_read(_buffA, buffer_f32);
			var _y00 = buffer_read(_buffA, buffer_f32);
			var _x10 = buffer_read(_buffA, buffer_f32);
			var _y10 = buffer_read(_buffA, buffer_f32);
			var _x01 = buffer_read(_buffB, buffer_f32);
			var _y01 = buffer_read(_buffB, buffer_f32);
			var _x11 = buffer_read(_buffB, buffer_f32);
			var _y11 = buffer_read(_buffB, buffer_f32);
			var _c = _collisions ? c_red : c_white;
			draw_line_color(_x00, _y00, _x10, _y10, _c, _c);
			draw_line_color(_x00, _y00, _x01, _y01, _c, _c);
			draw_line_color(_x11, _y11, _x10, _y10, _c, _c);
			draw_line_color(_x11, _y11, _x01, _y01, _c, _c);
		}
		
		// Return previous seek positions.
		buffer_seek(_buffA, buffer_seek_start, _tellA);
		buffer_seek(_buffB, buffer_seek_start, _tellB);
		buffer_seek(_buffResult, buffer_seek_start, _tellResult);
		return self;
	};
	
	
#endregion
// 
//==========================================================
//
#region USER HANDLES: FREE OR RESET DATASTRUCTURES.


	// Resets buffer sizes.
	static ResetBuffer = function()
	{
		buffer_resize(self.buffer.A, 64);
		buffer_resize(self.buffer.B, 64);
		buffer_resize(self.buffer.result, 64);
		buffer_seek(self.buffer.A, buffer_seek_start, 0);
		buffer_seek(self.buffer.B, buffer_seek_start, 0);
		return self;
	};
	
	
	// Free the datastructures.
	static Free = function()
	{
		if (surface_exists(self.surface.A))
			surface_free(self.surface.A);
			
		if (surface_exists(self.surface.B))
			surface_free(self.surface.B);
			
		if (surface_exists(self.surface.result))
			surface_free(self.surface.result);
		
		if (buffer_exists(self.buffer.A))
			buffer_delete(self.buffer.A);
			
		if (buffer_exists(self.buffer.B))
			buffer_delete(self.buffer.B);
		
		if (buffer_exists(self.buffer.result))
			buffer_delete(self.buffer.result);
		
		return self;
	};
	
	
#endregion
// 
//==========================================================
}






