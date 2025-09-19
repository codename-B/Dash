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
