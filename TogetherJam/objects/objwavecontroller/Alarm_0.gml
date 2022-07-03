/// @description Wave Difficulty

if (objGameController.isPlaying)
{
	global.waveDifficulty += 1;
	alarm[0] = (baseTimeBetweenDifficulty + increaseInTimeBetweenDifficulty * global.waveDifficulty) * room_speed;

	if (global.waveDifficulty == 1)
	{
		waveType = 1; //Airwolf always 2nd focus wave
	}
	else
	{
		waveType = floor(random(3));
	}
}