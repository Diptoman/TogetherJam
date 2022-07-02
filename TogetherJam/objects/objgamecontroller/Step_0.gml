//Slow mo
if (slowMoCooldown > 0)
{
	slowMoCooldown -= 1;
}
else
{
	objSlowMoUI.Activate(true);
}

if (inputdog_down("slowmo", playerSlot))
{
	if (slowMoCooldown <= 0)
	{
		if (global.slowmotimescale == 1)
		{
			global.slowmotimescale = 0.25;
			alarm[0] = slowMoDuration;
			objSlowMoUI.Activate(false);
		}
			
		slowMoCooldown = 300;
	}
}