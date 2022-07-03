if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))
{
	EndMoveUI();
	
	alarm[0] = 60;
}

if (keyboard_check_pressed(vk_escape))
{
	room_goto(rmMenu);
}