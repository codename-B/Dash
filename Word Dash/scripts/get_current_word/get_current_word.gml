function get_current_word() {
	var word = ""
	for(var i=0; i<array_length(global.tiles_to_play); i++) {
		var tile = global.tiles_to_play[i];
		if (tile.getVisible()) {
			word += tile._letter;
		}
	}
	return word;
}