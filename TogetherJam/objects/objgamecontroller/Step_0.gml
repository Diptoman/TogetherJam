//Slow mo
slowMoCooldown -= 1;
if (inputdog_down("slowmo", playerSlot))
{
	if (slowMoCooldown <= 0)
	{
		if (global.slowmotimescale == 1)
		{
			global.slowmotimescale = 0.25;
			alarm[0] = slowMoDuration;
		}
			
		slowMoCooldown = 300;
	}
}