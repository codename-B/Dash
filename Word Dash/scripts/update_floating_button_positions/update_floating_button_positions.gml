/// @function update_floating_button_positions()
/// @description Updates the position and visibility of floating buttons based on current word
function update_floating_button_positions() {
    var fb = instance_find(obj_floating_buttons, 0);
    if (fb == noone) {
        show_debug_message("Floating buttons object not found!");
        return;
    }
    
    // Check if we have current word tiles
    var has_current_word = variable_global_exists("current_word_tiles") && array_length(global.current_word_tiles) > 0;
    
    // Debug output
    if (has_current_word) {
        show_debug_message("Current word has " + string(array_length(global.current_word_tiles)) + " tiles");
    }
    
    // Update visibility
    fb.buttons_visible = has_current_word;
    
    // Only update positions if buttons should be visible
    if (has_current_word) {
        // Find the rightmost current word tile
        var rightmost_tile = undefined;
        var max_x = -infinity;
        
        for (var i = 0; i < array_length(global.current_word_tiles); i++) {
            var tile = global.current_word_tiles[i];
            if (instance_exists(tile) && tile.x > max_x) {
                max_x = tile.x;
                rightmost_tile = tile;
            }
        }
        
        if (rightmost_tile != undefined) {
            // Position buttons to the right of the rightmost tile
            var button_x = rightmost_tile.x + 100; // 100 pixels to the right
            var button_y = rightmost_tile.y - 10;  // Slightly above the tile
            
            // Position Enter button
            fb.enter_x = button_x;
            fb.enter_y = button_y;
            
            // Position Reset button below Enter button
            fb.reset_x = button_x;
            fb.reset_y = button_y + fb.button_height + fb.button_gap;
            
            show_debug_message("Positioned buttons at: " + string(button_x) + "," + string(button_y));
        } else {
            show_debug_message("No rightmost tile found!");
        }
    }
}
