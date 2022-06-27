/// @description Special Bombs

if (specialCount < 5)
{
	alarm[1] = bombGap;
	instance_create_layer(x, y, "Characters", objAirwolfBomb);
	specialCount += 1;
}
else
{
	specialCount = 0;
}