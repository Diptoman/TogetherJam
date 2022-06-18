function inputdog_replay_start_recording() {
	ds_map_clear(replayLog);
	replayMode = "record";
	replayFrame = 0;
	show_debug_message("recording started");



}
