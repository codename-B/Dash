var sw = sprite_get_width(sprite_index);
var sh = sprite_get_height(sprite_index);

// draw enough tiles to cover the whole gui view
for (var xx = -sw; xx <= display_get_gui_width(); xx += sw) {
    for (var yy = -sh; yy <= display_get_gui_height(); yy += sh) {
        draw_sprite(sprite_index, 0, x + xx, y + yy);
    }
}
