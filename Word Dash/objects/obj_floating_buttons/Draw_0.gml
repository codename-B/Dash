// Draw floating buttons if they are visible
if (buttons_visible) {
    // Set up drawing
    gpu_set_blendenable(true);
    gpu_set_blendmode(bm_normal);
    
    // Draw Enter button using the same sprite as recycle button
    var enter_sprite = enter_hover ? panel_transparent_center_015 : panel_border_015;
    draw_sprite_stretched(enter_sprite, 0, enter_x, enter_y, button_width, button_height);
    
    // Draw Enter button text
    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(enter_x + button_width/2, enter_y + button_height/2, "Enter");
    
    // Draw Reset button using the same sprite as recycle button
    var reset_sprite = reset_hover ? panel_transparent_center_015 : panel_border_015;
    draw_sprite_stretched(reset_sprite, 0, reset_x, reset_y, button_width, button_height);
    
    // Draw Reset button text
    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(reset_x + button_width/2, reset_y + button_height/2, "Reset");
    
    // Reset drawing settings
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
