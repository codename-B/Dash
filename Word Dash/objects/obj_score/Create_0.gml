global.score_ui = self
// ui layout
var width  = display_get_gui_width();
var height = display_get_gui_height();
// layout metrics
var tile_w = 100;
var tile_h = 100;
var gap    = 15;      // 150 + 5 = your 155 step
var side_w = 300;    // confirm/reset column
var panel_width = tile_w * 3;
var panel_height = tile_h * 1.5;                          // 305
var bottom_margin = 15; // change if you want a little breathing room
var panel_x = (width  - panel_width)  div 2;                 // centered X
var panel_y = (height - panel_height) - bottom_margin;       // stuck to bottom

_value = 0

_panel = new UIPanel("score", gap, gap, panel_width, panel_height, panel_border_015);
_panel.setResizable(false)
_panel.setMovable(false)
_text = new UIText("score_text", panel_width/2, panel_height/2, "[c_black]SCORE");
_score = new UIText("score_score", panel_width-36, panel_height-24, "[c_black][Kreon_Score]0");
_panel.add(_text);
_panel.add(_score);
