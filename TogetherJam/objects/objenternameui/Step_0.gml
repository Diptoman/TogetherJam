name = keyboard_string;

if ((keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) && name != "")
{
	global.playerName = name;
	UpdateDataFile(0, global.playerName);
	EndMoveUI();
	
	objMenuController.CallShowNameUI();
}