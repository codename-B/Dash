var ch = keyboard_lastchar;
var k = keyboard_lastkey;

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
if (k == vk_anykey) {
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
    ui_play_letter(letter_to_play);
}