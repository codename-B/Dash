if (!instance_exists(obj_player)) exit;

x -= obj_player.h_scroll * parallax_x;
y -= obj_player.v_scroll * parallax_y;

// wrap around so the background tiles infinitely
var sw = sprite_get_width(sprite_index);
var sh = sprite_get_height(sprite_index);

if (x <= -sw) x += sw;
if (x >= sw)  x -= sw;

if (y <= -sh) y += sh;
if (y >= sh)  y -= sh;
