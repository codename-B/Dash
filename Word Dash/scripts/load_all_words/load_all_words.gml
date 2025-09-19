function load_all_words(){
	global.wordlist = {}
	// US
	var wordlist = load_word_list_txt_optimized("wordlist_kevin_en_US_20201207_123679w.txt")
	for (var i = 0; i < array_length(wordlist); i++) {
		var word = wordlist[i]
		if (!struct_exists(global.wordlist, word) && !string_pos("-", word) > 0 && !string_pos(" ", word) > 0) {
			struct_set(global.wordlist, word, {"word": word})
		}
	}
	// UK
	var wordlist2 = load_word_list_txt_optimized("wordlist_marcoagpinto_20250901_280879w.txt")
	for (var i = 0; i < array_length(wordlist2); i++) {
		var word = wordlist2[i]
		if (!struct_exists(global.wordlist, word) && !string_pos("-", word) > 0 && !string_pos(" ", word) > 0) {
			struct_set(global.wordlist, word, {"word": word})
		}
	}
}