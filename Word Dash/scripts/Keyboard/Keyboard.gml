/// --- Helpers: simulate button actions from keyboard

function ui_play_letter(ch) {	
    ch = string_upper(ch);
    
    // Prevent duplicate processing of the same letter (reduced debounce for faster typing)
    if (variable_global_exists("last_played_letter") && variable_global_exists("last_played_time")) {
        if (global.last_played_letter == ch && current_time - global.last_played_time < 30) { // 30ms debounce
            return false;
        }
    }
    global.last_played_letter = ch;
    global.last_played_time = current_time;
    
    // find the first matching bottom tile (visible + enabled)
    for (var i = 0; i < array_length(global.tiles); i++) {
        var t = global.tiles[i];
        if (t.getVisible() && t.getEnabled() && t._letter == ch) {
            // find first empty top slot
            for (var j = 0; j < array_length(global.tiles_to_play); j++) {
                var top_tile = global.tiles_to_play[j];
                if (!top_tile.getVisible()) {
                    // perform the same action as your click callback
                    top_tile._text.setText(t._text.getText());
                    top_tile._letter = t._letter;
                    top_tile.setVisible(true);
                    top_tile._score.setText(t._score.getText());
                    top_tile._value = t._value;

                    t.setVisible(false);
                    t.setEnabled(false);
					play_letter_sound();
                    return true; // handled
                }
            }
            return false; // no top slot available
        }
    }
    // Play negative sound when no matching tile is found
    audio_play_sound(negative_sound2, 1.0, false);
    return false; // no matching tile found
}

function ui_activate_confirm() {
    if (!global.first_word_placed) {
        global.game_running = true;
        global.first_word_placed = true;
    }
    if (global.failed) {
        return;
    }
	
    var word = get_current_word();
	if (word == "") return;
    var scr  = get_word_score();

    if (!is_word_in_dictionary(word)) {
		audio_play_sound(negative_sound2, 1.0, false);
        global.failed = true;
    } else {
		audio_play_sound(Ding, 1.0, false);
        var score_ui = global.score_ui;
        score_ui._value += scr;
        score_ui._score.setText("[c_black][Kreon_Score]" + string(score_ui._value));
    }

    var last_tile = get_rightmost_instance_pos(obj_tile_parent);
    CreateWordWall(word, last_tile.x + 200, last_tile.y - 96);
    draw_new_tiles();
}

function ui_activate_reset() {
	audio_play_sound(Ding, 1.0, false);
    draw_new_tiles();
}

function ui_remove_letter() {
    // Early return if game is failed
    if (global.failed) {
        return false;
    }
    
    // Check if required objects exist
    if (!is_array(global.tiles_to_play) || !is_array(global.tiles)) {
        return false;
    }
    
    // Find the rightmost visible tile in the top row
    var rightmost_index = -1;
    for (var i = array_length(global.tiles_to_play) - 1; i >= 0; i--) {
        var top_tile = global.tiles_to_play[i];
        if (top_tile.getVisible()) {
            rightmost_index = i;
            break;
        }
    }
    
    // If no tiles are visible, nothing to remove
    if (rightmost_index == -1) {
        return false;
    }
    
    var top_tile = global.tiles_to_play[rightmost_index];
    var letter = top_tile._letter;
    
    // Find the corresponding bottom tile that was hidden and restore it
    for (var i = 0; i < array_length(global.tiles); i++) {
        var bottom_tile = global.tiles[i];
        if (!bottom_tile.getVisible() && !bottom_tile.getEnabled()) {
            // This bottom tile was hidden (played), restore it
            bottom_tile._text.setText(top_tile._text.getText());
            bottom_tile._letter = top_tile._letter;
            bottom_tile._score.setText(top_tile._score.getText());
            bottom_tile._value = top_tile._value;
            
            // Re-enable and reveal the tile
            bottom_tile.setVisible(true);
            bottom_tile.setEnabled(true);
            
            // Hide the top tile
            top_tile.setVisible(false);
            top_tile.setEnabled(false);
            
            play_letter_sound();
            return true; // handled
        }
    }
    
    return false; // no matching bottom tile found
}