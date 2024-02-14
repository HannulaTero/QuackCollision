/// @desc INPUTS


// Delete example.
if (keyboard_check_released(ord("R")))
	instance_destroy(parQuack_Example);
	
	
// Destroy thingies.
if (keyboard_check_released(vk_delete))
	instance_destroy(objQuack_Thing);
	
	
// Debug collision draw.
if (keyboard_check_released(vk_tab))
	debugDraw = !debugDraw;
	
	
// Info text draw.
if (keyboard_check_released(vk_space))
	infoDraw = !infoDraw;


// Create example.
if (keyboard_check_pressed(vk_anykey))
{
	switch(keyboard_key)
	{
		case ord("1"):
			instance_destroy(parQuack_Example);
			instance_create_depth(0, 0, 0, objQuack_Example_Simple_ParticleSystem);
			break;
		
		case ord("2"):
			instance_destroy(parQuack_Example);
			instance_create_depth(0, 0, 0, objQuack_Example_AABB_ParticleSystem);
			break;
			
		case ord("3"):
			instance_destroy(parQuack_Example);
			instance_create_depth(0, 0, 0, objQuack_Example_OBB_ParticleSystem);
			break;
			
		case ord("4"):
			instance_destroy(parQuack_Example);
			instance_create_depth(0, 0, 0, objQuack_Example_OBB_Miscellenous);
			break;
	}

}

