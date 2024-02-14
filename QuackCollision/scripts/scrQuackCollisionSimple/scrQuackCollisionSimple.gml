
/// @func	QuackCollisionSimple();
/// @desc	Do the collision with drawn quads with distance to center points.
function QuackCollisionSimple() constructor
{
//==========================================================
//
#region INSTANCE VARIABLE DECLARATION.


	self.surface = -1;		// For getting collisions.
	self.collisions = 0;	// How many collided with.			Range 0 to 255.
	self.total = 0;			// How many checks done overall.	Range 0 to 255.
	
	self.radius = 0;		// Particles' radius.
	self.collider = {};		// Which to check against.
	self.collider.x = 0;
	self.collider.y = 0;
	self.collider.radius = 0;
	
	
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
#region USER HANDLES: ADD COLLIDER AREA


	// Set up circle collision area.
	static AddArea = function(_x, _y, _radius=1)
	{
		self.collider.x = _x;
		self.collider.y = _y;
		self.collider.radius = _radius;
		return self;
	};
	
	// Set up circle collision area with instance.
	static AddInstance = function(_inst)
	{
		with(_inst)
		{
			var _x = mean(bbox_left, bbox_right);
			var _y = mean(bbox_top, bbox_bottom);
			var _radius = max((bbox_right - _x), (bbox_bottom - _y));
			other.AddArea(_x, _y, _radius);
		}
		return self;
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
		shader_set_uniform_f(uniPosition, self.collider.x, self.collider.y);
		shader_set_uniform_f(uniDistance, self.radius + self.collider.radius);
		return self;
	};
	
	
#endregion
// 
//==========================================================
//
#region USER HANDLES: SET PARAMETERS.


	// How far is will count as collision between points.
	static SetRadius = function(_radius=1)
	{
		self.radius = _radius;
		shader_set_uniform_f(uniDistance, self.radius + self.collider.radius);
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
#region USER HANDLES: GET RESULTS.


	// Get the count how many has collided.
	static GetCollisions = function()
	{
		gml_pragma("forceinline");
		return self.collisions;
	};
	
	
	// Minimal translation vector. 
	// This can't store in rgba8unorm, so not implemented.
	// Methods exist to have same methods with other versions.
	static GetX = function()
	{
		gml_pragma("forceinline");
		return 0;
	};
	
	
	static GetY = function()
	{
		gml_pragma("forceinline");
		return 0;
	};
	
	
	// Get total count of collision checks.
	static GetTotal = function()
	{
		gml_pragma("forceinline");
		return self.total;
	}
	
	
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
		self.total = buffer_peek(_buffer, 3, buffer_u8);
		buffer_delete(_buffer);
		return self.collisions;
	};	
	
	
#endregion
// 
//==========================================================
//
#region USER HANDLES: DEBUG DRAW.


	// Render collision area.
	static DebugDraw = function()
	{
		var _c = (self.collisions) ? c_red : c_white;
		draw_circle_color(self.collider.x, self.collider.y, self.collider.radius, _c, _c, true);
		return self;
	}
	

#endregion
// 
//==========================================================
//
#region USER HANDLES: FREE


	static Free = function()
	{
		// No action. 
		// This is here to have similar handles to other versions.
		// If simple is used correctly, then no datastructures are left.
		return self;
	};


#endregion
// 
//==========================================================
}



