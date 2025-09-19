/// --- Helpers: simulate button actions from keyboard

function ui_play_letter(ch) {	
    ch = string_upper(ch);
    
    // Prevent duplicate processing of the same letter (reduced debounce for faster typing)
    if (variable_global_exists("last_played_letter") && variable_global_exists("last_played_time")) {
        if (global.last_played_letter == ch && current_time - global.last_played_time < 30) { // 30ms debounce
            return false;
        }
    }
    global.last_played_letter = ch;
    global.last_played_time = current_time;
    
    // find the first matching bottom tile (visible + enabled)
    for (var i = 0; i < array_length(global.tiles); i++) {
        var t = global.tiles[i];
        if (t.getVisible() && t.getEnabled() && t._letter == ch) {
            // Directly place the tile instead of moving to top row
            place_tile_directly(t._letter, t._value);
            
            // Hide and disable this bottom tile
            t.setVisible(false);
            t.setEnabled(false);
            play_letter_sound();
            return true; // handled
        }
    }
    // Play negative sound when no matching tile is found
    audio_play_sound(negative_sound2, 1.0, false);
    return false; // no matching tile found
}

function ui_activate_confirm() {
    // Validate the current word and start a new line
    validate_current_word();
    draw_new_tiles();
}

function ui_activate_reset() {
	audio_play_sound(Ding, 1.0, false);
    draw_new_tiles();
}

function ui_clear_current_word() {
    // Clear current word and put tiles back in hand
    if (variable_global_exists("current_word_tiles") && array_length(global.current_word_tiles) > 0) {
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
        play_letter_sound();
    }
}

function ui_remove_letter() {
    // Early return if game is failed
    if (global.failed) {
        return false;
    }
    
    // Check if we have current word tiles to remove from
    if (!variable_global_exists("current_word_tiles") || array_length(global.current_word_tiles) == 0) {
        return false;
    }
    
    // Get the last tile from the current word
    var last_tile = array_pop(global.current_word_tiles);
    
    if (instance_exists(last_tile)) {
        // Find a hidden bottom tile to restore
        for (var i = 0; i < array_length(global.tiles); i++) {
            var bottom_tile = global.tiles[i];
            if (!bottom_tile.getVisible() && !bottom_tile.getEnabled()) {
                // Restore this bottom tile with the removed tile's letter
                bottom_tile._text.setText("[c_black]" + last_tile.letter);
                bottom_tile._letter = last_tile.letter;
                bottom_tile._score.setText("[c_black][Kreon]" + string(last_tile.score));
                bottom_tile._value = last_tile.score;
                
                // Re-enable and reveal the tile
                bottom_tile.setVisible(true);
                bottom_tile.setEnabled(true);
                
                // Remove the wall tile
                instance_destroy(last_tile);
                
                play_letter_sound();
                return true; // handled
            }
        }
    }
    
    return false; // no hidden bottom tile found to restore
}