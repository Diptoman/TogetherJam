if (keyboard_check_pressed(vk_control))
{
	EndMoveUI();
	
	objMenuController.CallEnterNameUI();
}

if (inputdog_down("select", playerSlot))
{
	alarm[0] = 5;
}