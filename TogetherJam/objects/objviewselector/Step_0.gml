/// @description Attach
if (instance_exists(target))
{
	y = lerp(y, target.y, .05);
	x = lerp(x, target.x, .05);
	var cameraY = lerp(camera_get_view_y(view_camera[0]), finalTargetY, 0.05); 

	camera_set_view_pos(view_camera[0], x, cameraY);	
}

if (inputdog_pressed("switch", playerSlot) && instance_exists(finalAirwolfRef) && instance_exists(finalKITTref))
{
	if (target == finalKITTref)
	{
		target = finalAirwolfRef;
		finalTargetY = 0;
		audio_sound_gain(finalAirwolfRef.airwolfsound, 1, 200);
		audio_sound_gain(finalKITTref.kittsound, 0.25, 200);
	}
	else
	{
		target = finalKITTref;
		finalTargetY = cameraJumpDistance;
		audio_sound_gain(finalAirwolfRef.airwolfsound, 0.25, 200);
		audio_sound_gain(finalKITTref.kittsound, 1, 200);
	}
	
	finalAirwolfRef.active = !finalAirwolfRef.active;
	finalKITTref.active = !finalKITTref.active;
}