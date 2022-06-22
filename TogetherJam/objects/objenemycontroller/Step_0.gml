timeBetweenEnemies -= 1;

//Test
if (timeBetweenEnemies <= 0)
{
	timeBetweenEnemies = 60;
	instance_create_layer(room_width + 64, random_range(40, 720), "Enemies", objAssBlaster);
}