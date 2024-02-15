========================================================

QUACK - Collide with drawn quads.
	Written for GameMaker Cookbook jam.
	By Tero Hannula
	
========================================================

GENERAL CONSIDERATIONS & INFO

This library is for GameMaker (check gamemaker.io)
	Made and tested with version: IDE v2023.11.1.129, Runtime v2023.11.1.160.
	
Note that this library is highly experimental.
	Special thanks for Gizmo199 for the idea.
 
Quack allows detecting collision with quads by drawing them, such as:
	Sprites.
	Text.
	Particle system.
	Physics particles.
 
Quack provides three ways to do collision detection.
	Simple	: Simple distance-based collision.
	AABB	: Axis-Aligned Bounding Box collision.	
	OBB		: Oriented Bounding Box collision.
	
Quack uses shader_enable_corner_id() for detecting vertex corners.
	If drawing function doesn't support this (eg. physics particles), 
	then you secondary approach of using texture coordinates.
	Secondary approach requires providing information of sprite being used.
	
Quack has creates separate camera to avoid automatic culling by GameMaker.
	static camera = camera_create_view(-16384, -16384, +32768, +32768);
	If you play outside this area, you might require to move the camera too.	
	
Surface requirements:
	Simple	: surface_rgba8unorm
	AABB	: surface_rgba32float
	OBB		: surface_rgba32float

Shader derivative requirements:
	Simple	: Not equired.
	AABB	: Required.
	OBB		: Required.
	
Quack collision information explanations:
	"Collisions" 	: Count of collisions for given target collider.
	"Total" 		: Total count of collision checks for given target collider.
	"MTV" 			: Minimum Translation Vector, how to move away from collision.
	
Quack collision support:
	Simple	: Collisions, Total. (Both up to 255)
	AABB	: Collisions, MTV, Total.
	OBB		: Collisions, MTV, Total.
	
Quack Simple allows only one target colliders, but as requirements are lower, it can be used with HTML5 export.

Quack AABB and OBB supports multiple target colliders at same time, which is more performance efficient, because Quack uses buffer_get_surface. This can be slow if done repeatly, so try maximize collision checks in one quack.End()

When using quack.AddInstance(inst), quack uses instance bounding box for determining collision area. 

Quack OBB supports angled instances: quack.AddInstanceAngled(inst), this calculates rotated bounding box. This calculation is done in GML.

By default Quack AABB and OBB discards previous target colliders. But if you wish so, you can do quack.AutomaticReset(false), and target colliders are not reset. This can of course lead to memory leak. But with this, you can also add non-updating instances and colliders once, and then later update them only when required with methods quack.SetArea() and quack.SetInstance(). 

Quack OBB uses Separating Axis Theorem for collision.

 
========================================================

HOW TO USE

1) 	Create Quack-struct in Create-event.
		Simple 	: quack = new QuackCollisionSimple();
		AABB 	: quack = new QuackCollisionAABB();
		OBB		: quack = new QuackCollisionOBB();
	
2) 	Use any Draw-event to handle collision, where following actions happen.
		Quack uses shaders and drawing for all approaches. 
		Drawing in GameMaker requires use of Draw-event.
	
3a) Add target collider areas. AABB and OBB returns index to identify collider.
		Simple	: quackSimple.AddArea(x, y, radius);
		AABB 	: index = quack.AddArea(xmin, ymin, xmax, ymax);
		OBB 	: index = quack.AddArea(x0, y0, x1, y1, x2, y2, x3, y3);
		
3b)	Alternatively add instance as target collider.
		Simple	: quack.AddInstance(inst);
		AABB 	: index = quack.AddInstance(inst); // Uses bounding box.
		OBB 	: index = quack.AddInstance(inst); // Uses bounding box.
		OBB 	: index = quack.AddInstanceAngled(inst); // Uses rotated bounding box.
		
4)	Begin the quack collision detection.
		quack.Begin();

5) 	Draw quads, such as sprites, text, and particle systems. 
		With Simple, change quad radius with quack.SetRadius(32.0);
		With AABB and OBB, change relative size of quad colliders with quack.SetScale(1.0)
		Some things do not support vertex corner id (shader_enable_corner_id).
		Then you must use quack.UseCoord(spr, img) to detect corners with texture coordinate.
		To return back to corner id, use quack.UseCorner();

6)	End the collision detection.
		quack.End();

7)	Get the collision information.
		Quack Simple:
			collisions = quack.GetCollisions();
			total = quack.GetTotal();
		Quack AABB and OBB:
			collisions = quack.GetCollisions(index);
			xmove = quack.GetX(index);
			ymove = quack.GetY(index);
			total = quack.GetTotal(index);
			
8)	Use collision information however you want.
		image_blend = (collisions > 0) ? c_red : c_white;
		x += xmove;
		y += ymove;
		draw_text(x, y - 16, $"{collisions} / {total} collisions.");
		
9)	To debug, you can render target collider areas.
		quack.DebugDraw();
		
10)	Finally free the Quack when not required anymore, like in Clean Up event.
		quack.Free();


========================================================

HOW QUACK WORKS?

Let's take Quack Simple for the first example.
	The render area is just surface with size of 1x1.
	Vertex shader modifies all drawn quads to cover whole render area.
	Pass positions into fragment shader as "varying".
	As "varying" are interpolated.
	Coordinate is vec2(0.5, 0.5), so it results to be middle point of quad.
	Now in fragment shader check distance with given point and quad middle point.
	Cumulative results allow counting collisions and checks.
	
The same approach is used with AABB and OBB collisions, but with following differences.
	The render area depens on target colliders, one pixel for each target.
	This means varying won't be interpolated well, each fragment has different positions.
	To combat with this, derivatives are taken to get rate of change.
	With this, corners can be computated by current position and fragment coordinate.
	After knowing quad vertex corner positions, collider can be constructed.
	Texture stores target collider information, which are read and collider constructed.
	Now collision check is made.
	If target collides with quad, then Minimum Translation Vector is also calculated.
	


========================================================