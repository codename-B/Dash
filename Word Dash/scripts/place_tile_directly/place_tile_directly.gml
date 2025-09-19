/// @function place_tile_directly(letter, value)
/// @description Places a tile to build up the current word
/// @param {string} letter The letter to place
/// @param {real} value The point value of the letter
function place_tile_directly(letter, value) {
    // Don't start the game yet - wait for first word validation
    
    // Don't place tiles if game has failed
    if (global.failed) {
        return;
    }
    
    // Initialize current word tracking if it doesn't exist
    if (!variable_global_exists("current_word_tiles")) {
        global.current_word_tiles = [];
    }
    
    // Find the rightmost tile position (either validated wall or current word)
    var last_validated_tile = get_rightmost_instance_pos(obj_wall);
    var last_current_tile = undefined;
    
    // Check if we have current word tiles to find the rightmost one
    if (array_length(global.current_word_tiles) > 0) {
        var max_x = -infinity;
        for (var i = 0; i < array_length(global.current_word_tiles); i++) {
            var tile = global.current_word_tiles[i];
            if (instance_exists(tile) && tile.x > max_x) {
                max_x = tile.x;
                last_current_tile = tile;
            }
        }
    }
    
    var start_x = 250; // Default starting position
    var start_y = room_height - 300;
    
    // Use the rightmost tile (either validated or current word)
    if (last_current_tile != undefined && last_validated_tile != undefined) {
        if (last_current_tile.x > last_validated_tile.x) {
            start_x = last_current_tile.x + (96 - 4);
            start_y = last_current_tile.y;
        } else {
            start_x = last_validated_tile.x + 200;
            start_y = last_validated_tile.y - 96;
        }
    } else if (last_current_tile != undefined) {
        start_x = last_current_tile.x + (96 - 4);
        start_y = last_current_tile.y;
    } else if (last_validated_tile != undefined) {
        start_x = last_validated_tile.x + 200;
        start_y = last_validated_tile.y - 96;
    }
    
    // Calculate position for this new tile in the current word
    var tile_width = 96 - 4;
    var new_x = start_x;
    
    // Create a fake wall tile (will be converted to real wall when word is validated)
    var new_wall = instance_create_layer(new_x, start_y, "Instances", obj_fake_wall);
    new_wall.letter = letter;
    new_wall.score = value;
    new_wall.value = string(value);
    
    // Add to current word tracking
    array_push(global.current_word_tiles, new_wall);
    
    // Play success sound
    audio_play_sound(Ding, 1.0, false);
}
