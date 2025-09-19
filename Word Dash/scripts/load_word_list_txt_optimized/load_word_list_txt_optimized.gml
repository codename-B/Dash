/// @function load_word_list_txt_optimized(filename)
/// @description Loads a word list from a text file with optimized performance
/// @param {string} filename The path to the text file to load
/// @returns {any} Array<String> of processed words
function load_word_list_txt_optimized(filename) {
    // Check if file exists first (faster than trying to open)
    if (!file_exists(filename)) {
        show_debug_message("Error: File does not exist: " + filename);
        return [];
    }
    
    // Load entire file into memory at once - much faster than line-by-line
    var buffer = buffer_load(filename);
    if (buffer == -1) {
        show_debug_message("Error: Could not load file " + filename);
        return [];
    }
    
    // Convert buffer to string in one operation
    var file_content = buffer_read(buffer, buffer_string);
    buffer_delete(buffer);
    
    // Split into lines using built-in string functions
    var lines = string_split(file_content, "\n");
    var word_count = array_length(lines);
    
    // Pre-allocate array with known size (avoids dynamic resizing)
    var word_list = array_create(word_count);
    var actual_word_count = 0;
    
    // Process all lines in a single loop
    for (var i = 0; i < word_count; i++) {
        var line = string_trim(lines[i]); // Also trim whitespace
        
        // Skip empty lines (check length first - it's faster)
        if (string_length(line) > 0) {
            // Combine operations: lowercase and remove apostrophes in one step
            var processed_word = string_lower(string_replace_all(line, "'", ""));
            
            // Only add if still valid after processing
            if (string_length(processed_word) > 0) {
                word_list[actual_word_count] = processed_word;
                actual_word_count++;
            }
        }
    }
    
    // Resize array to actual size if needed
    if (actual_word_count < word_count) {
        array_resize(word_list, actual_word_count);
    }
    
    show_debug_message("Loaded " + string(actual_word_count) + " words from " + filename);
    return word_list;
}

/// @function load_word_list_txt_async(filename, callback)
/// @description Asynchronously loads a word list to avoid blocking the game
/// @param {string} filename The path to the text file to load
/// @param {function} callback Function to call when loading is complete
function load_word_list_txt_async(filename, callback) {
    // For very large files, you might want to load asynchronously
    // This is a basic implementation - you could enhance it further
    
    var load_data = {
        filename: filename,
        callback: callback,
        start_time: current_time
    };
    
    // Start the async load
    async_load_start(load_data);
}

/// @function async_load_start(load_data)
/// @description Helper function for async loading
function async_load_start(load_data) {
    // You would implement this based on your specific needs
    // This could use alarms, coroutines, or break the loading into chunks
    var word_list = load_word_list_txt_optimized(load_data.filename);
    load_data.callback(word_list);
}