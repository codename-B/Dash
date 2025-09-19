function RetryGame() {
    show_debug_message("GAME RESTARTING...");
	
    // 1. Destroy all existing game elements
	var _start_x = obj_player.start_x;
    var _start_y = obj_player.start_y;
    instance_destroy(obj_player);
    instance_destroy(obj_tile_parent);

    // 2. Reset global game state variables
    global.game_running = false;
    global.first_word_placed = false;
	global.failed = false;
	global.words_played = []
	global.current_word_tiles = []
    
	var score_ui = global.score_ui
	score_ui._value = 0
	score_ui._score.setText("[c_black][Kreon_Score]" + string(score_ui._value))
    
    // 3. Reset the tile bag and draw a fresh hand for the player
    tilebag_build_from_master_and_shuffle();
    global.hand_tiles = draw_tiles(10);

    // 4. Reset the UI to reflect the new hand
    // This code is similar to your initial setup logic.
    for (var i = 0; i < array_length(global.tiles); i++) {
        // Reset the bottom row (hand tiles) with the new letters
        var bottom_tile = global.tiles[i];
        var hand_tile_data = global.hand_tiles[i];
        
        // Safety check to ensure hand_tile_data is valid
        if (hand_tile_data != undefined && hand_tile_data.letter != undefined && hand_tile_data.value != undefined) {
            bottom_tile.setVisible(true);
            bottom_tile.setEnabled(true);
            bottom_tile._text.setText("[c_black]" + hand_tile_data.letter);
            bottom_tile._score.setText("[c_black][Kreon]" + string(hand_tile_data.value));
            bottom_tile._value = hand_tile_data.value;
            bottom_tile._letter = hand_tile_data.letter;
        }
    }
    
    // 5. Re-create the initial game world
    // Re-spawn the player
    instance_create_layer(_start_x, _start_y - 100, "Instances", obj_player);
    
    // Re-spawn the "AGAIN" wall (create real walls for initial word)
    CreateWordWall("AGAIN", 250, room_height - 300, true);
	global.words_played = []
	// Add the initial word to the words played list
	array_push(global.words_played, "AGAIN");
	
	obj_game_controller._replay.setVisible(false)
	obj_game_controller._confirm.setVisible(true)
	obj_game_controller._reset.setVisible(true)
}