/// @description Insert description here
// You can write your code in this editor

playerSlot = 1;

//Loot Locker
LootLockerInitialize("64669fa3c7f23c6e3105f62d3b5b972504e0b82b", "1.0.0", false, 4490);
LootLockerTurnOnAutoRefresh();

alarm[0] = 60;

//State 
step = 1;

//Read data
global.gamedata = ds_list_create();
data = file_text_open_read("GameData.tt");
if (data == -1)
{
	data = file_text_open_write("GameData.tt");
	file_text_close(data);
}
else
{
	ds_list_read(global.gamedata, file_text_read_string(data));
	file_text_close(data);
}

if (ds_list_size(global.gamedata) == 0)
{
	ds_list_add(global.gamedata, "");
	ds_list_add(global.gamedata, 0);
	data = file_text_open_write("GameData.tt");
	file_text_write_string(data, ds_list_write(global.gamedata));
	file_text_close(data);
}

global.highscore = ds_list_find_value(global.gamedata, 1);
global.playerName = ds_list_find_value(global.gamedata, 0);

//Functions
function CallEnterNameUI()
{
	a = instance_create_layer(room_width/2, room_height + 200, "Controllers", objEnterNameUI);
	a.InitializeMoveUI(room_width / 2, y + camera_get_view_height(view_camera[0]) / 2 - 32);
	step = 1;
}

function CallShowNameUI()
{
	a = instance_create_layer(room_width/2, room_height + 200, "Controllers", objDisplayNameUI);
	a.InitializeMoveUI(room_width / 2, y + camera_get_view_height(view_camera[0]) / 2 - 32);
	step = 2;
}

//Menu setup
if (global.playerName == "")
{
	CallEnterNameUI();
}
else
{
	CallShowNameUI();
}

instance_create_layer(room_width / 2, y + 200, "Controllers", objTwinTurbo);

//Browser adjustment
/*if (os_browser == os_browser)
{
	var a = browser_width;
	var b = browser_height;

	if(a < room_width)
	{
		b = (camera_get_view_height(view_camera[0])/room_width) * a
		window_set_size(a, b);
	}
	else if(b < camera_get_view_height(view_camera[0]))
	{
		a = (room_width/camera_get_view_height(view_camera[0])) * b
		window_set_size(a, b);
	}
}*/

audio_stop_all();
menu = audio_play_sound(sndMenuBGM, 100, true);