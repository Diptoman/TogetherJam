if (inputdog_down("select", playerSlot))
{
	EndMoveUI();
	
	alarm[0] = 45;
}

if (inputdog_down("escape", playerSlot))
{
	alarm[1] = 5;
}