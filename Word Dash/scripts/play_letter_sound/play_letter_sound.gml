function play_letter_sound() {
	var sounds = [typewriter3, typewriter4, typewriter6]
	audio_play_sound(sounds[random(3)], 1.0, false);
}