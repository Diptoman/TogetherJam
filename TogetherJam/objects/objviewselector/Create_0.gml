/// @description Init

target = -1;
playerSlot = 1;
finalKITTref = -1;
finalAirwolfRef = -1;
finalTargetY = 0;
cameraJumpDistance = 60;

function Initialize(airwolfref, kittref, startwithkitt = true)
{
	kittref.active = startwithkitt;
	airwolfref.active = !startwithkitt;
	finalKITTref = kittref;
	finalAirwolfRef = airwolfref;
	
	if (startwithkitt)
	{
		target = kittref;
		finalTargetY = room_height;
	}
	else
	{
		target = airwolfref;
		finalTargetY = 0;
	}
	
	camera_set_view_target(view_camera[0], self);
}