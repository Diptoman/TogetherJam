event_inherited();

//Test
if (keyboard_check_pressed(vk_space))
{
	attachNum += 1;
	ringAttachNum += 1;
	if (ringAttachNum > currentSpace)
	{
		currentSpace += currentSpaceIncrement;
		currentSpaceIncrement += 2;
		attachRing += 1;
		ringAttachNum = 0;
	}
	instance_create(0, 0, objHeli);
}