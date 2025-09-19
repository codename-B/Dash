// Update floating button positions and visibility directly
var has_current_word = variable_global_exists("current_word_tiles") && array_length(global.current_word_tiles) > 0;
buttons_visible = has_current_word;

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
        enter_x = button_x;
        enter_y = button_y;
        
        // Position Reset button below Enter button
        reset_x = button_x;
        reset_y = button_y + button_height + button_gap;
    }
}


// Handle mouse interactions
if (buttons_visible) {
    // Transform mouse coordinates to world space to account for camera movement
    var mx = mouse_x;
    var my = mouse_y;
    
    // Apply camera offset if player exists
    if (instance_exists(obj_player)) {
        // The tiles move by -h_scroll and -v_scroll, so we need to apply the same offset to mouse coords
        mx += obj_player.h_scroll;
        my += obj_player.v_scroll;
    }
    
    // Check enter button hover
    enter_hover = (mx >= enter_x && mx <= enter_x + button_width && 
                   my >= enter_y && my <= enter_y + button_height);
    
    // Check reset button hover
    reset_hover = (mx >= reset_x && mx <= reset_x + button_width && 
                   my >= reset_y && my <= reset_y + button_height);
    
    // Handle clicks
    if (mouse_check_button_pressed(mb_left)) {
        if (enter_hover) {
            // Validate the current word and start a new line
            validate_current_word();
            draw_new_tiles();
        } else if (reset_hover) {
            // Clear the current word using the existing draw_new_tiles function
            show_debug_message("Clearing current word...");
            
            // Don't clear if game has failed
            if (global.failed) {
                show_debug_message("Game failed, not clearing");
                return;
            }
            
            // Check if we have current word tiles to clear
            if (!variable_global_exists("current_word_tiles") || array_length(global.current_word_tiles) == 0) {
                show_debug_message("No current word tiles to clear");
                return;
            }
            
            show_debug_message("Clearing " + string(array_length(global.current_word_tiles)) + " tiles");
            
            // Use the existing draw_new_tiles function which handles this correctly
            draw_new_tiles();
            
            show_debug_message("Current word cleared successfully");
        }
    }
}
