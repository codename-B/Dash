// This code will run in obj_wall and all other child tiles.
if (!instance_exists(obj_player)) exit;

// Move based on the player's scroll variables
x -= obj_player.h_scroll;
y -= obj_player.v_scroll;

// Destroy when off-screen
if (x < -100 || 0 < -100) {
    instance_destroy();
}