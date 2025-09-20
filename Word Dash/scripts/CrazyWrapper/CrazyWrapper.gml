function get_best_word() {
    var best_word = "";

    // Try to get best word from CrazyGames (if available)
    try {
        if (crazy_started()) {
            var cg_word = crazy_data_get_item("best_word");
            if (is_string(cg_word)) best_word = cg_word;
        }
    } catch (e) {
        show_debug_message("Error getting best word from CrazyGames: " + string(e));
        best_word = "";
    }

    // Determine the single highest-scoring local word
    var top_local = "";
    if (is_array(global.words_played) && array_length(global.words_played) > 0) {
        var pq = ds_priority_create();
        for (var i = 0; i < array_length(global.words_played); i++) {
            var w = global.words_played[i];
            var s = get_word_score_by_word(w);
            ds_priority_add(pq, w, s); // higher score => higher priority
        }
        if (ds_priority_size(pq) > 0) {
            top_local = ds_priority_find_max(pq); // effectively "first after sorting desc by score"
        }
        ds_priority_destroy(pq);
    }

    // If we have a local candidate, compare (unless best_word is empty)
    if (top_local != "") {
        if (best_word == "") {
            best_word = top_local;
        } else if (get_word_score_by_word(top_local) > get_word_score_by_word(best_word)) {
            best_word = top_local;
        }

        // Persist back to CrazyGames if connected
        try {
            if (crazy_started()) {
                crazy_data_set_item("best_word", best_word);
            }
        } catch (e2) {
            show_debug_message("Error setting best word to CrazyGames: " + string(e2));
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