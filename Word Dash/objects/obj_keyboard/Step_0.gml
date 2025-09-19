// Handle continuous backspace key holding
if (keyboard_check(vk_backspace)) {
    // Check if this is the first press or if enough time has passed for continuous deletion
    if (!variable_global_exists("backspace_held") || current_time - global.backspace_last_time >= 150) { // 150ms delay for continuous deletion
        global.backspace_held = true;
        global.backspace_last_time = current_time;
        
        // Only delete if we're not in the initial press phase (handled by KeyPress event)
        if (current_time - global.backspace_initial_time > 500) { // 500ms initial delay before continuous deletion starts
            ui_remove_letter();
        }
    }
} else {
    // Reset backspace state when key is released
    global.backspace_held = false;
}
