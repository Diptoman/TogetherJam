/// @description Enemy Spawn

//Set next
if (objGameController.isPlaying)
{
	alarm[1] = max(lowestTimeBetweenEnemies, random_range(baseMinTimeBetweenEnemies - decreaseInTimeBetweenEnemiesPerDifficulty, baseMaxTimeBetweenEnemies - decreaseInTimeBetweenEnemiesPerDifficulty)) * room_speed;

	if (waveType == 0) //KITT focused
	{
		if (global.waveDifficulty <= 3)
		{
			num = 1;
			PickAndSpawnEnemies(num, 1, 3, 0, 2);
		}
		else if (global.waveDifficulty <= 8)
		{
			num = choose(1, 2);
			PickAndSpawnEnemies(num, 2, 3, 0, 2);
		}
		else if (global.waveDifficulty <= 12)
		{
			num = choose(1, 1, 2, 2, 2, 2, 3);
			PickAndSpawnEnemies(num, 3, 3, 0, 2);
		}
		else
		{
			num = choose(2, 2, 3);
			PickAndSpawnEnemies(num, 3, 3, 0, 2);
		}
	}
	else if (waveType == 1) //Airwolf focused
	{
		if (global.waveDifficulty <= 4)
		{
			num = 1;
		}
		else if (global.waveDifficulty <= 8)
		{
			num = choose(1, 2);
		}
		else if (global.waveDifficulty <= 12)
		{
			num = choose(1, 1, 2, 2, 2, 2, 3);
		}
		else
		{
			num = choose(2, 2, 3);
		}
		
		PickAndSpawnEnemies(num, 0, 0, 2, 1);
	}
	else if (waveType == 2) //Mixed
	{
		if (global.waveDifficulty <= 4)
		{
			num = 1;
		}
		else if (global.waveDifficulty <= 8)
		{
			num = choose(1, 2);
		}
		else if (global.waveDifficulty <= 12)
		{
			num = choose(1, 1, 2, 2, 2, 2, 3);
		}
		else
		{
			num = choose(2, 2, 3);
		}
		
		PickAndSpawnEnemies(num, 1, 0, 1, 1);
	}

	//Add civilian
	HandleCivilianSpawn();
}