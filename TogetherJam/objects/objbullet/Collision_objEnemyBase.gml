/// @description Do damage

if (x < room_width)
{
	other.hp -= damage;
	instance_destroy();
}