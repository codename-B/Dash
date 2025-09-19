// This code will run in obj_wall and all other child tiles.
if (!instance_exists(obj_player)) exit;

// Move based on the player's scroll variables
x -= obj_player.h_scroll;
y -= obj_player.v_scroll;

var width  = display_get_gui_width();
var height = display_get_gui_height();

// Destroy when off-screen
if (x < -width || y < -height) {
    instance_destroy();
}