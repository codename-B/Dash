/// @function create_floating_buttons()
/// @description Creates the floating buttons for current word actions
function create_floating_buttons() {
    // Get reference to floating buttons object
    var fb = instance_find(obj_floating_buttons, 0);
    if (fb == noone) {
        show_debug_message("Floating buttons object not found!");
        return;
    }
    
    // Check if buttons already exist
    if (fb.enter_button != noone || fb.reset_button != noone) {
        show_debug_message("Floating buttons already exist!");
        return;
    }
    
    // Create Enter button
    fb.enter_button = new UIButton("floating_enter", 0, 0, fb.button_width, fb.button_height, "[c_black]Enter", panel_border_015);
    if (fb.enter_button != noone) {
        fb.enter_button.setSpriteClick(panel_transparent_center_015);
        fb.enter_button.setVisible(false);
        
        // Set up callback
        fb.enter_button.setCallback(UI_EVENT.LEFT_RELEASE, method(fb.enter_button, function() {
            // Validate the current word and start a new line
            validate_current_word();
            draw_new_tiles();
        }));
    }
    
    // Create Reset button  
    fb.reset_button = new UIButton("floating_reset", 0, 0, fb.button_width, fb.button_height, "[c_black]Reset", panel_border_015);
    if (fb.reset_button != noone) {
        fb.reset_button.setSpriteClick(panel_transparent_center_015);
        fb.reset_button.setVisible(false);
        
        // Set up callback
        fb.reset_button.setCallback(UI_EVENT.LEFT_RELEASE, method(fb.reset_button, function() {
            // Clear the current word
            clear_current_word();
        }));
    }
}
