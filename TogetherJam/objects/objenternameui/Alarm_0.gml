/// @description Insert description here
// You can write your code in this editor
global.playerName = name;
UpdateDataFile(0, global.playerName);
LootLockerSetPlayerName(global.playerName);
EndMoveUI();
	
objMenuController.CallShowNameUI();