/// @description Insert description here
// You can write your code in this editor
isOn = true;
image_speed = 0;
image_index = 1;

function Activate(on)
{
	if (on)
	{
		isOn = true;
		sprite_index = spr_SlowmoActive;
		image_speed = 0.8;
	}
	else
	{
		isOn = false;
		sprite_index = spr_SlowmoInactive;
	}
}