name = string_copy(keyboard_string, max(1, string_length(keyboard_string) - 15), 15);

if ((keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) && name != "")
{
	global.playerName = name;
	UpdateDataFile(0, global.playerName);
	LootLockerSetPlayerName(global.playerName);
	EndMoveUI();
	
	objMenuController.CallShowNameUI();
}