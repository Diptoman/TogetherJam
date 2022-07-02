/// @description Init

//Timescale
global.timescale = 1;
global.slowmotimescale = 1;
slowMoCooldown = 30;
slowMoDuration = 150;
playerSlot = 1;

global.civiliansaved = 0;
global.civilianmissed = 0;
global.maxciviliansMissed = 5;

global.topMovementLimit = 64;
global.botMovementLimit = 1080;
global.AirwolfBotMovementLimit = 520;
global.KITTTopMovementLimit = 720;

//HP
global.hp = 100;
global.currenthp = global.hp;

//Power and numbers
global.power = 100;
global.number = 1;

instance_create_layer(x, y, "Controllers", objWaveController);
instance_create_layer(x, y, "Controllers", objBackgroundController);
airwolf = instance_create_layer(160, 160, "Characters", objAirwolf);
kitt = instance_create_layer(160, 840, "Characters", objKITT);
viewSelector = instance_create_layer(kitt.x, kitt.y, "Controllers", objViewSelector);
viewSelector.Initialize(airwolf, kitt);
instance_create_layer(0, camera_get_view_y(view_camera[0]), "Controllers", objUIController);

function CivilianMissed()
{
	global.civilianmissed += 1;
	objUIController.UpdateDeathUI(global.civilianmissed - 1);
	instance_create_layer(x, y, "Controllers", objScreenShake);
}
