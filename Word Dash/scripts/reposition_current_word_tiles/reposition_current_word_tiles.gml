/// @function reposition_current_word_tiles()
/// @description Repositions all current word tiles after one has been removed
function reposition_current_word_tiles() {
    if (!variable_global_exists("current_word_tiles") || array_length(global.current_word_tiles) == 0) {
        return;
    }
    
    // Find the rightmost validated tile position to place the new word
    var last_validated_tile = get_rightmost_instance_pos(obj_wall);
    var start_x = 250; // Default starting position
    var start_y = room_height - 300;
    
    if (last_validated_tile != undefined) {
        start_x = last_validated_tile.x + 200;
        start_y = last_validated_tile.y - 96;
    }
    
    // Reposition all current word tiles
    var tile_width = 96 - 4;
    for (var i = 0; i < array_length(global.current_word_tiles); i++) {
        var tile = global.current_word_tiles[i];
        if (instance_exists(tile)) {
            var new_x = start_x + (i * tile_width);
            tile.x = new_x;
        }
    }
}
