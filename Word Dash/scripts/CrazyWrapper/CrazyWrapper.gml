function get_best_word() {
    var best_word = "";
    // Get best word from CrazyGames if available
    try {
        if (crazy_started()) {
            best_word = crazy_data_get_item("best_word");
        }
    } catch (e) {
        console.log("Error getting best word from CrazyGames: " + string(e));
        best_word = ""; // Reset to default value
    }
    
    // Check local words against best_word
    if (is_array(global.words_played)) {
        for (var i = 0; i < array_length(global.words_played); i++) {
            var current_word = global.words_played[i];
            // Replace with your own criteria for "better word"
            if (get_word_score_by_word(current_word) > get_word_score_by_word(best_word)) {
                best_word = current_word;
                // Override CrazyGames value if connected
                try {
                    if (crazy_started()) {
                        crazy_data_set_item("best_word", best_word);
                    }
                } catch (e) {
                    console.log("Error setting best word to CrazyGames: " + string(e));
                }
            }
        }
    }
    return best_word;
}

function get_best_score() {
    var best = 0;
    // Check CrazyGames best_score if available
    try {
        if (crazy_started()) {
            var crazy_best = crazy_data_get_item("best_score");
            if (crazy_best != undefined) {
                best = crazy_best;    
            }
        }
    } catch (e) {
        console.log("Error getting best score from CrazyGames: " + string(e));
        best = 0; // Reset to default value
    }
    
    // Loop through global scores and compare
    if (is_array(global.scores)) {
        for (var i = 0; i < array_length(global.scores); i++) {
            if (global.scores[i] > best) {
                best = global.scores[i];
                // Override the CrazyGames value if connected
                try {
                    if (crazy_started()) {
                        crazy_data_set_item("best_score", best);
                    }
                } catch (e) {
                    console.log("Error setting best score to CrazyGames: " + string(e));
                }
            }
        }
    }
    return best;
}