/// @desc SELECT EXAMPLE

if (!keyboard_check_released(vk_anykey))
	exit;

// Delete example.
if (keyboard_check(vk_delete))
{
	instance_destroy(parQuack_Example);
}

// Create example.
switch(keyboard_lastchar)
{
	case "1":
		instance_destroy(parQuack_Example);
		instance_create_depth(0, 0, 0, objQuack_Example_Simple_ParticleSystem);
		break;
		
	case "2":
		instance_destroy(parQuack_Example);
		instance_create_depth(0, 0, 0, objQuack_Example_AABB_ParticleSystem);
		break;
	case "3":
		instance_destroy(parQuack_Example);
		instance_create_depth(0, 0, 0, objQuack_Example_OBB_ParticleSystem);
		break;
}


























































