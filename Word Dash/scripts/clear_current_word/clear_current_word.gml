/// @function clear_current_word()
/// @description Clears the current word being built and returns tiles to hand
function clear_current_word() {
    show_debug_message("clear_current_word called");
    
    // Don't clear if game has failed
    show_debug_message("Checking if game failed...");
    if (global.failed) {
        show_debug_message("Game failed, not clearing");
        return;
    }
    show_debug_message("Game not failed, continuing...");
    
    // Check if we have current word tiles to clear
    show_debug_message("Checking for current word tiles...");
    if (!variable_global_exists("current_word_tiles") || array_length(global.current_word_tiles) == 0) {
        show_debug_message("No current word tiles to clear");
        return;
    }
    
    show_debug_message("Clearing " + string(array_length(global.current_word_tiles)) + " tiles");
    
    // Play sound (commented out to prevent crash)
    // audio_play_sound(Ding, 1.0, false);
    
    // Return tiles to hand
    for (var i = 0; i < array_length(global.current_word_tiles); i++) {
        var tile = global.current_word_tiles[i];
        if (instance_exists(tile)) {
            // Find the corresponding hand tile and restore it
            for (var j = 0; j < array_length(global.tiles); j++) {
                var hand_tile = global.tiles[j];
                // Add safety checks for UI methods
                if (hand_tile != undefined && hand_tile._letter == tile.letter) {
                    // Check if the hand tile is hidden (not visible)
                    var is_visible = false;
                    if (typeof(hand_tile.getVisible) == "function") {
                        is_visible = hand_tile.getVisible();
                    }
                    
                    if (!is_visible) {
                        // Restore the hand tile
                        if (typeof(hand_tile.setVisible) == "function") {
                            hand_tile.setVisible(true);
                        }
                        if (typeof(hand_tile.setEnabled) == "function") {
                            hand_tile.setEnabled(true);
                        }
                        break;
                    }
                }
            }
            
            // Destroy the current word tile
            instance_destroy(tile);
        }
    }
    
    // Clear the current word tiles array
    global.current_word_tiles = [];
}
