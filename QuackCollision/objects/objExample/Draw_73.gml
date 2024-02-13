/// @desc PARTICLE COLLISION CHECK

//part_system_drawit(particlesOther);
part_system_drawit(particlesSmoke);

shader_enable_corner_id(true);
draw_sprite(sprWhite, 1, 320, 320);
physics_particle_draw(flags, 0, sprWhite, 0);
shader_enable_corner_id(false);

draw_self();

// Get targets to collide against
var _index = quackOBB.AddInstance(self);
with(objCollider)
{
	self.index = other.quackOBB.AddInstance(self);
}

// Get the collisions with sprites.
quackOBB.Begin();
{
//	part_system_drawit(particlesOther);
	part_system_drawit(particlesSmoke);
	draw_sprite(sprParticle, 1, 320, 320);
	quackOBB.UseCoord(sprParticle, 0);
	physics_particle_draw(flags, 0, sprParticle, 0);
}
quackOBB.End();


// Do things with collisions.
var _total = quackOBB.GetTotal(_index);
var _collisions = quackOBB.Get(_index);
quackOBB.GetMtv(_index);
x += quackOBB.mtvX;
y += quackOBB.mtvY;
image_blend = (_collisions > 0) ? c_red : c_white;
image_index = (_collisions > 0) ? 1 : 0;
var _c = c_lime;
draw_text_color(x, y-160, _total, _c, _c, _c, _c, 1);
draw_text_color(x, y-128, _collisions, _c, _c, _c, _c, 1);
draw_text_color(x, y-96, quackOBB.mtvX, _c, _c, _c, _c, 1);
draw_text_color(x, y-64, quackOBB.mtvY, _c, _c, _c, _c, 1);
draw_self();

var _red = make_color_hsv(0, 128, 255);
with(objCollider)
{
	_collisions = other.quackOBB.Get(self.index);
	other.quackOBB.GetMtv(self.index);
	x += other.quackOBB.mtvX;
	y += other.quackOBB.mtvY;
	image_blend = (_collisions > 0) ? _red : c_dkgray;
	image_index = (_collisions > 0) ? 1 : 0;
}

/*
repeats += mouse_wheel_down() - mouse_wheel_up();
quackSimple.Begin(x, y, 128);
var i = 0;
repeat(repeats)
	draw_sprite(sprWhite, 1, 320, 320+i++);
quackSimple.End();
draw_text_color(x, y-64, quackSimple.collisions, _c, _c, _c, _c, 1);
draw_text_color(x, y-96, (quackSimple.collisions==repeats), _c, _c, _c, _c, 1);
draw_text_color(x, y-128, quackSimple.counter, _c, _c, _c, _c, 1);

