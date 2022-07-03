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
			instance_create_layer(x, y, "SlowMo", objSlowMoOverlay);
			alarm[0] = slowMoDuration;
			objSlowMoUI.Activate(false);
		}
			
		slowMoCooldown = 300;
	}
}

if (inputdog_down("escape", playerSlot))
{
	alarm[2] = 5;
}

if (global.power > global.maxpower)
{
	global.maxpower = global.power;
}

if (global.number > global.maxNumber)
{
	global.maxNumber = global.number;
}

if (isPlaying)
{
	global.distance += 1;
	global.score = global.distance + global.maxNumber * 100 + global.maxpower + global.civiliansaved * 100 + global.creaturesKilled * 50 - global.creaturesMissed * 25;
}

//Audio
if (!audio_is_playing(global.bgm))
{
	global.bgm = audio_play_sound(choose(sndBGM1, sndBGM2, sndBGM3), 100, false);
}