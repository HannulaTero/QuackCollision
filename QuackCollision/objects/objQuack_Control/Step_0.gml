/// @desc INPUTS


// Delete example.
if (keyboard_check_released(ord("0")))
	instance_destroy(parQuack_Example);
	
	
// Info text draw.
if (keyboard_check_released(vk_f1))
	infoDraw = !infoDraw;
	
	
// Debug collision draw.
if (keyboard_check_released(vk_f2))
	debugDraw = !debugDraw;

	
// Debug overlay draw.
if (keyboard_check_released(vk_f3))
{
	overlayDraw = !overlayDraw;
	show_debug_overlay(overlayDraw, true);
}

// Destroy thingies.
if (keyboard_check_released(vk_f4))
	instance_destroy(objQuack_Thing);
	

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
			instance_create_depth(0, 0, 0, objQuack_Example_OBB_Text);
			break;
			
		case ord("5"):
			instance_destroy(parQuack_Example);
			instance_create_depth(0, 0, 0, objQuack_Example_OBB_Miscellenous);
			break;
	}

}

