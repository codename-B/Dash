/// --- Helpers: simulate button actions from keyboard

function ui_play_letter(ch) {	
    ch = string_upper(ch);
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