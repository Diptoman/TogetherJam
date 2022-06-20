event_inherited();

//Set targetPos
target = instance_find(objAirwolf, 0);
attachNumber = target.ringAttachNum;
attachRing = target.attachRing;
currentSpace = target.currentSpace;

//Speed
attachSpeed = random_range(0.15, 0.2);

//Temp
image_xscale = 0.5;
image_yscale = 0.5;