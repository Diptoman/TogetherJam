/// @description Spawn

image_speed = 0;
image_index = 4;

if (type == 1)
{
	instance_create_layer(x, y, "Enemies", objDirtDragon);
}
else if (type == 2)
{
	instance_create_layer(x, y, "Enemies", objGraboid);
}