function get_current_word() {
	var word = ""
	for(var i=0; i<array_length(global.tiles_to_play); i++) {
		var tile = global.tiles_to_play[i];
		if (tile.getVisible()) {
			// Safety check to ensure _letter is defined and is a string
			if (tile._letter != undefined && is_string(tile._letter)) {
				word += tile._letter;
			}
		}
	}
	return word;
}