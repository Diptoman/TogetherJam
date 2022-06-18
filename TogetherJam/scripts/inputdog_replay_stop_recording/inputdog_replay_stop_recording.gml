function inputdog_replay_stop_recording() {
	inputdog_replay_file_save();
	replayMode = "idle";
	show_debug_message("recording stopped");



}
