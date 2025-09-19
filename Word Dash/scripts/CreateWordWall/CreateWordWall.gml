/// @function               CreateWordWall(word, start_x, start_y)
/// @param {string} word    The word to build the wall from.
/// @param {real}   start_x The starting x-position of the first letter.
/// @param {real}   start_y The y-position for all letters.
function CreateWordWall(_word, _start_x, _start_y) {
    _word = string_upper(_word); // Ensure word is uppercase
    var _tile_width = 96-4; // The width of your obj_wall sprite

    // Loop through each character in the provided word
	if (is_word_in_dictionary(_word)) {
		array_push(global.words_played, _word)	
	}
	
    for (var i = 0; i < string_length(_word); i++) {
        var _char = string_char_at(_word, i + 1);
        
        // Calculate the position for this new tile
        var _new_x = _start_x + (i * _tile_width);
        
        // Create a new wall instance
		if (is_word_in_dictionary(_word)) {
			var _new_wall = instance_create_layer(_new_x, _start_y, "Instances", obj_wall);
        
			// Assign the character to the new wall tile
			_new_wall.letter = _char;
			_new_wall.score = struct_get(global.tile_data, _char).value
			_new_wall.value = string(_new_wall.score)
		} else {
			var _new_wall = instance_create_layer(_new_x, _start_y, "Instances", obj_fake_wall);
        
			// Assign the character to the new wall tile
			_new_wall.letter = _char;
			_new_wall.score = struct_get(global.tile_data, _char).value
			_new_wall.value = string(_new_wall.score)
		}
    }
}