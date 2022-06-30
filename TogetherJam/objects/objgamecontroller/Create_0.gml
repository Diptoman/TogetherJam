/// @description Init
airwolf = instance_create_layer(72, 72, "Characters", objAirwolf);
kitt = instance_create_layer(72, 840, "Characters", objKITT);
viewSelector = instance_create_layer(kitt.x, kitt.y, "Controllers", objViewSelector);
viewSelector.Initialize(airwolf, kitt);
instance_create_layer(x, y, "Controllers", objWaveController);

//Timescale
global.timescale = 1;
global.slowmotimescale = 1;
slowMoCooldown = 30;
slowMoDuration = 150;
playerSlot = 1;

global.civiliansaved = 0;
global.civilianmissed = 0;

global.kittpower = 1;