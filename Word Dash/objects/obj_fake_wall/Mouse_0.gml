// Handle clicking on fake wall tiles to remove them and put them back in hand
if (global.failed) {
    return; // Don't allow clicking if game has failed
}

// Find this tile in the current word tiles array
var tile_index = -1;
for (var i = 0; i < array_length(global.current_word_tiles); i++) {
    if (global.current_word_tiles[i] == id) {
        tile_index = i;
        break;
    }
}

if (tile_index == -1) {
    return; // This tile is not in the current word
}

// Find a hidden bottom tile to restore
for (var i = 0; i < array_length(global.tiles); i++) {
    var bottom_tile = global.tiles[i];
    if (!bottom_tile.getVisible() && !bottom_tile.getEnabled()) {
        // Restore this bottom tile with the removed tile's letter
        bottom_tile._text.setText("[c_black]" + letter);
        bottom_tile._letter = letter;
        bottom_tile._score.setText("[c_black][Kreon]" + string(score));
        bottom_tile._value = score;
        
        // Re-enable and reveal the tile
        bottom_tile.setVisible(true);
        bottom_tile.setEnabled(true);
        
        // Remove this tile from the current word array
        array_delete(global.current_word_tiles, tile_index, 1);
        
        // Destroy this fake wall tile
        instance_destroy();
        
        // Play sound
        play_letter_sound();
        
        // Reposition remaining tiles to fill the gap
        reposition_current_word_tiles();
        
        return;
    }
}
