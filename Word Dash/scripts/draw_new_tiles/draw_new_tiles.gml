function draw_new_tiles() {
    // Put current word tiles back in hand before clearing
    if (variable_global_exists("current_word_tiles")) {
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
    }
    
	// Count how many tiles are currently played (hidden bottom tiles)
    var played_count = 0;
    
    for (var i = 0; i < array_length(global.tiles); i++) {
        var bottom_tile = global.tiles[i];
        if (!bottom_tile.getVisible()) {
            played_count++;
        }
    }
    
    // Only proceed if there are tiles to reset
    if (played_count > 0) {
        // Draw new tiles from the pool (only the number that were played)
        var new_tiles = draw_tiles(played_count);
        
        // Find the corresponding bottom tiles that were hidden and update them with new tiles
        for (var i = 0; i < array_length(global.tiles); i++) {
            var bottom_tile = global.tiles[i];
            if (!bottom_tile.getVisible()) {
                // This bottom tile was hidden (played), so update it with a new tile
                var new_hand_tile = array_pop(new_tiles);
                // Safety check to ensure new_hand_tile is valid
                if (new_hand_tile != undefined && new_hand_tile.letter != undefined && new_hand_tile.value != undefined) {
                    // Update the tile's display with new letter and value
                    bottom_tile._text.setText("[c_black]" + new_hand_tile.letter);
                    bottom_tile._score.setText("[c_black][Kreon]" + string(new_hand_tile.value));
                    bottom_tile._value = new_hand_tile.value;
                    bottom_tile._letter = new_hand_tile.letter
                    
                    // Update the hand_tiles array
                    global.hand_tiles[i] = new_hand_tile;
                    
                    // Re-enable and reveal the tile
                    bottom_tile.setVisible(true);
                    bottom_tile.setEnabled(true);
                }
            }
        }
    }
}