/// @function validate_current_word()
/// @description Validates the current word being built and starts a new line
function validate_current_word() {
    // Check if we have a current word to validate
    if (!variable_global_exists("current_word_tiles") || array_length(global.current_word_tiles) == 0) {
        return false;
    }
    
    // Build the word from the current tiles
    var current_word = "";
    for (var i = 0; i < array_length(global.current_word_tiles); i++) {
        var tile = global.current_word_tiles[i];
        if (instance_exists(tile)) {
            current_word += tile.letter;
        }
    }
    
    // Check if we have a word to validate
    if (current_word == "") {
        return false;
    }
    
    // Validate the word
    if (is_word_in_dictionary(current_word)) {
        // Start the game if this is the first word validated
        if (!global.first_word_placed) {
            global.game_running = true;
            global.first_word_placed = true;
            if (crazy_started()) {
                crazy_game_gameplay_start()
            }
            if (!global.sound) {
                global.sound = true
                audio_play_sound(ink_on_paper_lofi_296412_ogg_q4, 1.0, true)
            }
        }
        
        // Valid word - play success sound
        audio_play_sound(Ding, 1.0, false);
        
        // Calculate and add score for the word
        var word_score = 0;
        for (var i = 0; i < array_length(global.current_word_tiles); i++) {
            var tile = global.current_word_tiles[i];
            if (instance_exists(tile)) {
                word_score += tile.score;
            }
        }
        
        // Update score
        var score_ui = global.score_ui;
        if (score_ui != undefined) {
            score_ui._value += word_score;
            score_ui._score.setText("[c_black][Kreon_Score]" + string(score_ui._value));
        }
        
        // Convert all fake walls to real walls since the word is valid
        for (var i = 0; i < array_length(global.current_word_tiles); i++) {
            var tile = global.current_word_tiles[i];
            if (instance_exists(tile)) {
                var new_wall = instance_create_layer(tile.x, tile.y, "Instances", obj_wall);
                new_wall.letter = tile.letter;
                new_wall.score = tile.score;
                new_wall.value = tile.value;
                instance_destroy(tile);
            }
        }
        
        // Clear the current word tracking
        global.current_word_tiles = [];
        
        return true;
    } else {
        // Invalid word - play error sound
        audio_play_sound(negative_sound2, 1.0, false);
        
        // Put the letters back in the hand instead of destroying them
        for (var i = 0; i < array_length(global.current_word_tiles); i++) {
            var tile = global.current_word_tiles[i];
            if (instance_exists(tile)) {
                // Find a hidden bottom tile to restore
                for (var j = 0; j < array_length(global.tiles); j++) {
                    var bottom_tile = global.tiles[j];
                    if (!bottom_tile.getVisible() && !bottom_tile.getEnabled()) {
                        // Restore this bottom tile with the removed tile's letter
                        bottom_tile._text.setText("[c_black]" + tile.letter);
                        bottom_tile._letter = tile.letter;
                        bottom_tile._score.setText("[c_black][Kreon]" + string(tile.score));
                        bottom_tile._value = tile.score;
                        
                        // Re-enable and reveal the tile
                        bottom_tile.setVisible(true);
                        bottom_tile.setEnabled(true);
                        break;
                    }
                }
                instance_destroy(tile);
            }
        }
        global.current_word_tiles = [];
        
        // Only mark as failed if the game has already started (first word was validated)
        if (global.first_word_placed) {
            global.failed = true;
        }
        
        return false;
    }
}
