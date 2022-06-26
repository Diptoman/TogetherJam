//Create groups of shriekers

instance_create_layer(x, y, "Enemies", objShrieker);
for(i = 0; i < min(1 + global.waveDifficulty / 2 + round(random(1)), 16); i++)
{
	if (i < 8)
	{
		instance_create_layer(x + lengthdir_x(64, 45*i), y + lengthdir_y(48, 45*i), "Enemies", objShrieker);
	}
	else if (i < 16)
	{
		instance_create_layer(x + lengthdir_x(128, 45*i), y + lengthdir_y(96, 45*i), "Enemies", objShrieker);
	}
}