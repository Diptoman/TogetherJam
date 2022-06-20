event_inherited();

//Set targetPos
target = instance_find(objAirwolf, 0);
attachNumber = target.ringAttachNum;
attachRing = target.attachRing;
currentSpace = target.currentSpace;

//Speed
baseAttachSpeed = random_range(0.2, 0.35);
attachSpeed = baseAttachSpeed / attachRing;

//Temp
image_xscale = 0.5;
image_yscale = 0.5;