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
            if (string_length(current_word) > string_length(best_word)) {
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