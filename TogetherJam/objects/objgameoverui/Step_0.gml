if (inputdog_down("select", playerSlot))
{
	EndMoveUI();
	
	alarm[0] = 60;
}

if (inputdog_down("escape", playerSlot))
{
	alarm[1] = 5;
}