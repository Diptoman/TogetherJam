/// @description Insert description here
//Movement
var d = inputdog_direction("up","down","left","right",playerSlot);
if(d == -1)
    speed = 0;
else
{  
    var s = point_distance(0,0, -inputdog_analog("left",playerSlot)+inputdog_analog("right",playerSlot),
                                -inputdog_analog("up",playerSlot)+inputdog_analog("down",playerSlot))
    motion_set(d,3 * s);
}
