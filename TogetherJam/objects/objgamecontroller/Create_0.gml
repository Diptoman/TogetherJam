/// @description Init
LootLockerInitialize("64669fa3c7f23c6e3105f62d3b5b972504e0b82b", "1.0.0", false, 4490);
alarm[1] = 60;
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
global.maxpower = global.power;
global.number = 1;
global.maxNumber = global.number;
global.distance = 0;
global.score = 0;
global.creaturesKilled = 0;
global.graboidsKilled = 0;
global.assBlastersKilled = 0;
global.dirtdragonsKilled = 0;
global.shriekersKilled = 0;
global.creaturesMissed = 0;
isPlaying = true;

instance_create_layer(x, y, "Controllers", objWaveController);
instance_create_layer(x, y, "Controllers", objBackgroundController);
airwolf = instance_create_layer(160, 192, "Characters", objAirwolf);
kitt = instance_create_layer(160, 840, "Characters", objKITT);
viewSelector = instance_create_layer(kitt.x, kitt.y, "Controllers", objViewSelector);
viewSelector.Initialize(airwolf, kitt);
instance_create_layer(0, camera_get_view_y(view_camera[0]), "Controllers", objUIController);

function EndGame()
{
	global.timescale = 0;
	a = instance_create_layer(room_width/2, room_height + 240, "Controllers", objGameOverUI);
	a.InitializeMoveUI(room_width / 2, y + camera_get_view_height(view_camera[0]) / 2);
	isPlaying = false;
	objKITT.active = false;
	audio_stop_sound(objKITT.kittsound);
	objAirwolf.active = false;
	audio_stop_sound(objAirwolf.airwolfsound);
	audio_play_sound(sndGameOver, 95, false);
}

function CivilianMissed()
{
	global.civilianmissed += 1;
	objUIController.UpdateDeathUI(global.civilianmissed - 1);
	instance_create_layer(x, y, "Controllers", objScreenShake);
	audio_play_sound(sndCivilianDeath, 75, false);
	
	if (global.civilianmissed >= 5)
	{
		EndGame();
	}
}