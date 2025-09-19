/// @function is_word_in_dictionary(word_string)
/// @description Checks if a word is valid, handling '?' as a wildcard.
/// @param {string} word_string The word to check.
function is_word_in_dictionary(word_string) {
	return true
    var word = string_lower(word_string);
    
    // Find the position of the first wildcard character '?'
    var wildcard_pos = string_pos("?", word);

    // --- RECURSIVE CASE: Wildcard found ---
    // If a wildcard exists, we test every possible letter in its place.
    if (wildcard_pos > 0) {
        // Loop through the alphabet from 'a' to 'z'.
        for (var i = ord("a"); i <= ord("z"); i++) {
            var current_letter = chr(i);
            
            // Create a new word string by replacing the wildcard with the current letter.
            var new_word = string_copy(word, 1, wildcard_pos - 1) + 
                           current_letter + 
                           string_copy(word, wildcard_pos + 1, string_length(word));
            
            // Call this function recursively with the new word.
            // If any of the combinations are a valid word, we can stop and return true immediately.
            if (is_word_in_dictionary(new_word)) {
                return true;
            }
        }
        
        // If we've looped through all letters and found no valid words, this path is a dead end.
        return false;
    }

    // --- BASE CASE: No wildcard found ---
    // If there's no wildcard, we perform the final dictionary check.
    else {
        show_debug_message("Checking word: " + word);

        // We disallow 1-length words, they're no fun.
        if (string_length(word) <= 1) {
            show_debug_message("Rejected: Word is 1 letter or less.");
            return false;
        }

        if (struct_exists(global.wordlist, word)) {
            show_debug_message("Accepted: Word '" + word + "' found in dictionary.");
            return true;
        }

        show_debug_message("Rejected: Word '" + word + "' not in dictionary.");
        return false;
    }
}
