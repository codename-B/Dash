var ch = keyboard_lastchar;
var k = keyboard_lastkey;

// Safety checks for undefined values
if (is_undefined(ch)) ch = "";
if (is_undefined(k)) k = 0;

// Additional safety check to ensure k is a valid number
if (!is_real(k)) k = 0;

// Try using keyboard_check_pressed for special keys first
if (keyboard_check_pressed(vk_enter)) {
    show_debug_message("Enter detected via keyboard_check_pressed");
    ui_activate_confirm();
    return;
}

if (keyboard_check_pressed(vk_backspace)) {
    show_debug_message("Backspace detected via keyboard_check_pressed");
    global.backspace_initial_time = current_time;
    global.backspace_last_time = current_time;
    ui_remove_letter();
    return;
}

// Debug output to see what we're getting
show_debug_message("Key: " + string(k) + ", Char: '" + string(ch) + "', vk_enter: " + string(vk_enter) + ", vk_backspace: " + string(vk_backspace));

// Also check character codes as backup
if (ch == chr(13) || ch == "\r" || ch == "\n") {
    show_debug_message("Enter detected via character");
    ui_activate_confirm();
    return;
}

if (ch == chr(8) || ch == "\b") {
    show_debug_message("Backspace detected via character");
    global.backspace_initial_time = current_time;
    global.backspace_last_time = current_time;
    ui_remove_letter();
    return;
}

// Check if we have a valid letter from keyboard_lastchar
var letter_from_char = "";
if (is_string(ch) && string_length(ch) == 1) {
    var uch = string_upper(ch);
    var code = ord(uch);
    if (code >= ord("A") && code <= ord("Z")) {
        letter_from_char = uch;
    }
}

// Check if we have a valid letter from keyboard_lastkey
var letter_from_key = "";
if (is_real(k) && k >= ord("A") && k <= ord("Z")) {
    letter_from_key = chr(k);
}

// Only trigger once - prioritize keyboard_lastchar if both are valid
var letter_to_play = "";
if (letter_from_char != "") {
    letter_to_play = letter_from_char;
} else if (letter_from_key != "") {
    letter_to_play = letter_from_key;
}

// Play the letter if we found one
if (letter_to_play != "") {
    show_debug_message("Playing letter: " + letter_to_play);
    ui_play_letter(letter_to_play);
} else {
    show_debug_message("No valid letter found - char: '" + string(ch) + "', key: " + string(k));
}