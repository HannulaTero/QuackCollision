
/// @func	QuackCollisionSimple();
/// @desc	Do the collision with drawn quads with distance to center points.
function QuackCollisionSimple() constructor
{
//==========================================================
//
#region INSTANCE VARIABLE DECLARATION.


	self.surface = -1;		// For getting collisions.
	self.collisions = 0;	// How many collided with. Max 255.
	self.counter = 0;		// How many checks done overall. Max 255.
	
	
#endregion
// 
//==========================================================
//
#region STATIC VARIABLE DECLARATION.


	// Previous stores previous shaders to return them back after computation.
	// Camera is needed to avoid GM automatic culling. 
	static previous = [-1]; // Previous shaders.
	static camera = camera_create_view(-16384, -16384, +32768, +32768);
	static shader = shdQuackCollisionSimple;
	
	
#endregion
// 
//==========================================================
//
#region SHADER UNIFORMS.


	static uniUseCorner = shader_get_uniform(shader, "uniUseCorner");
	static uniCoordMiddle = shader_get_uniform(shader, "uniCoordMiddle");
	static uniPosition = shader_get_uniform(shader, "uniPosition");
	static uniDistance = shader_get_uniform(shader, "uniDistance");
	
	
#endregion
// 
//==========================================================
//
#region USER HANDLES: BEGIN COMPUTATION.


	// Start checking for collision with given position.
	static Begin = function(_x, _y, _dist=1)
	{
		// Store previous GPU settings.
		gpu_push_state();
		array_push(previous, shader_current());
	
		// Setup the target surface. Following rendering happen here.
		self.surface = surface_create(1, 1);
		surface_set_target(self.surface);
		draw_clear_alpha(c_black, 0); // Make sure no remnants.
	
		// Setup the GPU settings.
		shader_set(shader);
		gpu_set_tex_filter(false);
		gpu_set_tex_repeat(false);
		gpu_set_blendenable(true);
		gpu_set_blendmode_ext(bm_one, bm_one);
		camera_apply(camera); // To avoid GM automatic culling.
		UseCorner(); // By default use corner id's.
	
		// Setup the other uniforms.
		shader_set_uniform_f(uniPosition, _x, _y);
		shader_set_uniform_f(uniDistance, _dist);
		return self;
	};
	
	
#endregion
// 
//==========================================================
//
#region USER HANDLES: SET PARAMETERS.


	// How far is will count as collision between points.
	static SetDistance = function(_dist=1)
	{
		shader_set_uniform_f(uniDistance, _dist);
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


	// Returns the result of whether any collided.
	static End = function()
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
	
		// Get the results.
		var _buffer = buffer_create(4, buffer_fixed, 1);
		buffer_get_surface(_buffer, self.surface, 0);
		surface_free(self.surface);
		self.collisions = buffer_peek(_buffer, 0, buffer_u8);
		self.counter = buffer_peek(_buffer, 3, buffer_u8);
		buffer_delete(_buffer);
		return self.collisions;
	};	

	
#endregion
// 
//==========================================================
}



