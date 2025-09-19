function get_word_score(){
	var scr = 0
	for(var i=0; i<array_length(global.tiles_to_play); i++) {
		var tile = global.tiles_to_play[i];
		if (tile.getVisible()) {
			// Safety check to ensure _value is defined and is a number
			if (tile._value != undefined && is_real(tile._value)) {
				scr += tile._value;
			}
		}
	}
	return scr;
}

/// @function get_word_score_by_word(word)
/// @description Calculates the score of a word based on letter values in global.tile_data.
/// @param {string} word   The word to be scored.
/// @return {real}         The total calculated score for the word.

function get_word_score_by_word(word) {
	// Initialize the score variable to 0.
	var scr = 0;
	
	// Convert the input word to uppercase to match the keys in global.tile_data.
	var _upper_word = string_upper(word);
	
	// Get the length of the word to loop through it.
	var _word_len = string_length(_upper_word);
	
	// Loop through each character of the word.
	// Note: GameMaker strings are 1-indexed, so the loop starts at 1.
	for (var i = 1; i <= _word_len; i++) {
		// Get the character at the current position.
		var _char = string_char_at(_upper_word, i);
		
		// Check if the character exists as a key in the tile data.
		// This prevents errors if the word contains spaces, numbers, or punctuation.
		if (variable_struct_exists(global.tile_data, _char)) {
			// If the character is valid, get its score from the struct and add it to the total.
			// The '$' accessor is used to access struct members with a variable key.
			scr += global.tile_data[$ _char].value;
		}
	}
	
	// Return the final, total score.
	return scr;
}