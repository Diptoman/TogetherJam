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
	}
	else
	{
		target = finalKITTref;
		finalTargetY = cameraJumpDistance;
	}
	
	finalAirwolfRef.active = !finalAirwolfRef.active;
	finalKITTref.active = !finalKITTref.active;
}