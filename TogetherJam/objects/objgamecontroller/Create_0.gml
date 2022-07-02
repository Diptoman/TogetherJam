/// @description Init

//Timescale
global.timescale = 1;
global.slowmotimescale = 1;
slowMoCooldown = 30;
slowMoDuration = 150;
playerSlot = 1;

global.civiliansaved = 0;
global.civilianmissed = 0;

global.kittpower = 1;

global.topMovementLimit = 64;
global.botMovementLimit = 1080;
global.AirwolfBotMovementLimit = 520;
global.KITTTopMovementLimit = 720;

instance_create_layer(x, y, "Controllers", objWaveController);
instance_create_layer(x, y, "Controllers", objBackgroundController);
airwolf = instance_create_layer(160, 160, "Characters", objAirwolf);
kitt = instance_create_layer(160, 840, "Characters", objKITT);
viewSelector = instance_create_layer(kitt.x, kitt.y, "Controllers", objViewSelector);
viewSelector.Initialize(airwolf, kitt);

function CivilianMissed()
{
	global.civilianmissed += 1;
}
