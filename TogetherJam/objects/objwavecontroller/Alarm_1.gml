/// @description Enemy Spawn

//Set next
alarm[1] = max(lowestTimeBetweenEnemies, random_range(baseMinTimeBetweenEnemies - decreaseInTimeBetweenEnemiesPerDifficulty, baseMaxTimeBetweenEnemies - decreaseInTimeBetweenEnemiesPerDifficulty)) * room_speed;

if (waveType == 0) //KITT focused
{
	PickAndSpawnEnemies(1, 1, 1, 0, 1);
}
else if (waveType == 1) //Airwolf focused
{
	PickAndSpawnEnemies(1, 0, 0, 1, 1);	
}
else if (waveType == 2) //Mixed
{
	PickAndSpawnEnemies(1, 1, 1, 1, 1);	
}

//Add civilian
HandleCivilianSpawn();