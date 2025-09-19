// 1. Draw the object's own sprite first (the wall texture)
draw_self();

// 2. If this wall tile has a letter, draw it in the center.
if (letter != "") {
    scribble("[c_black]" + letter).draw(x+96/2, y+96/2)
	scribble("[c_black][Kreon]" + value).draw(x+96 - 16, y+96 - 16)
}

draw_sprite(cracks_b, 0, x, y);