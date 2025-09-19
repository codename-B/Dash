function draw_new_tiles() {
	// Count how many tiles are currently played (visible in top row)
    var played_count = 0;
    
    for (var i = 0; i < array_length(global.tiles_to_play); i++) {
        var top_tile = global.tiles_to_play[i];
        if (top_tile.getVisible()) {
            played_count++;
			top_tile.setVisible(false);
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