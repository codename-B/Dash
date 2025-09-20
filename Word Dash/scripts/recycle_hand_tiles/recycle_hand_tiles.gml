function recycle_hand_tiles() {
	// Count how many tiles are currently in the hand (and not in the top row)
	var recycle_count = 0;
	for (var i = 0; i < array_length(global.tiles); i++) {
		var bottom_tile = global.tiles[i];
		if (bottom_tile.getVisible()) {
			recycle_count++;
		}
	}
	
	// Only proceed if there are tiles to recycle
	if (recycle_count > 0) {
		// Draw new tiles from the pool
		var new_tiles = draw_tiles(recycle_count);
		
		// Iterate through the hand tiles and replace the ones that are visible
		for (var i = 0; i < array_length(global.tiles); i++) {
			var bottom_tile = global.tiles[i];
			if (bottom_tile.getVisible()) {
				// This bottom tile is in the hand, so update it with a new tile
				var new_hand_tile = array_pop(new_tiles);
				
				// Safety check to ensure new_hand_tile is valid
				if (new_hand_tile != undefined && new_hand_tile.letter != undefined && new_hand_tile.value != undefined) {
					// Update the tile's display with new letter and value
					bottom_tile._text.setText("[c_black]" + new_hand_tile.letter);
					bottom_tile._score.setText("[c_black][Kreon]" + string(new_hand_tile.value));
					bottom_tile._value = new_hand_tile.value;
					bottom_tile._letter = new_hand_tile.letter;
					
					// Update the hand_tiles array
					global.hand_tiles[i] = new_hand_tile;
				}
			}
		}
	}
}