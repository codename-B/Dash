function get_best_word() {
    var best_word = "";
    // Get best word from CrazyGames if available
    if (crazy_started()) {
        best_word = crazy_data_get_item("best_word");
    }
    // Check local words against best_word
    if (is_array(global.words_played)) {
        for (var i = 0; i < array_length(global.words_played); i++) {
            var current_word = global.words_played[i];
            // Replace with your own criteria for "better word"
            if (get_word_score_by_word(current_word) > get_word_score_by_word(best_word)) {
                best_word = current_word;
                // Override CrazyGames value if connected
                if (crazy_started()) {
                    crazy_data_set_item("best_word", best_word);
                }
            }
        }
    }
    return best_word;
}

function get_best_score() {
    var best = 0;
    // Check CrazyGames best_score if available
    if (crazy_started()) {
        var crazy_best = crazy_data_get_item("best_score");
        if (crazy_best != undefined) {
            best = crazy_best;    
        }
    }
    // Loop through global scores and compare
    if (is_array(global.scores)) {
        for (var i = 0; i < array_length(global.scores); i++) {
            if (global.scores[i] > best) {
                best = global.scores[i];
                // Override the CrazyGames value if connected
                if (crazy_started()) {
                    crazy_data_set_item("best_score", best);
                }
            }
        }
    }
    return best;
}