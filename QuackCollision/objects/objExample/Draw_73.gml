/// @desc PARTICLE COLLISION CHECK

//part_system_drawit(particlesOneBuiltin);
//part_system_drawit(particlesOneCustom);
part_system_drawit(particlesSmoke);
part_system_drawit(particlesOther);

shader_enable_corner_id(true);
draw_sprite(sprWhite, 1, 320, 320);
physics_particle_draw(flags, 0, sprWhite, 0);
shader_enable_corner_id(false);

draw_self();

// Get targets to collide against
var _index = quackAABB.AddInstance(self);
with(objCollider)
{
	self.index = other.quackAABB.AddInstance(self);
}

// Get the collisions with sprites.
quackAABB.Begin();
{
	part_system_drawit(particlesOther);
	part_system_drawit(particlesSmoke);
	draw_sprite(sprParticle, 1, 320, 320);

	quackAABB.UseCoord(sprParticle, 0);
}
quackAABB.End();


// Do things with collisions.
var _collided = quackAABB.Get(_index);
image_blend = _collided ? c_red : c_white;
image_index = _collided ? 1 : 0;
var _c = c_lime;
draw_text_color(x, y-32, _collided, _c, _c, _c, _c, 1);

var _red = make_color_hsv(0, 128, 255);
with(objCollider)
{
	_collided = other.quackAABB.Get(self.index);
	image_blend = _collided ? _red : c_white;
	image_index = _collided ? 1 : 0;
}

repeats += mouse_wheel_down() - mouse_wheel_up();
quackSimple.Begin(x, y, 128);
var i = 0;
repeat(repeats)
	draw_sprite(sprWhite, 1, 320, 320+i++);
quackSimple.End();
draw_text_color(x, y-64, quackSimple.collisions, _c, _c, _c, _c, 1);
draw_text_color(x, y-96, (quackSimple.collisions==repeats), _c, _c, _c, _c, 1);
draw_text_color(x, y-128, quackSimple.counter, _c, _c, _c, _c, 1);

