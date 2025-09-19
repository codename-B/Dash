if (crazy_started()) {
	crazy_game_loading_start()	
}
// Add this to your existing controller variables
global.words_played = []
global.scores = []
global.game_running = false;
global.first_word_placed = false;
global.failed = false
global.sound = false
// globals
load_all_words()
global.master_tile_collection = [];
global.expedition_tile_bag = [];
// ~122 tiles total; ~42% vowels for smoother 10-tile racks
global.tile_data = {
  A: { value: 10, count: 9 },  B: { value: 30, count: 3 },  C: { value: 25, count: 3 },
  D: { value: 20, count: 5 },  E: { value: 10, count: 15 }, F: { value: 35, count: 3 },
  G: { value: 20, count: 4 },  H: { value: 40, count: 3 },  I: { value: 10, count: 11 },
  J: { value: 80, count: 1 },  K: { value: 50, count: 2 },  L: { value: 10, count: 5 },
  M: { value: 30, count: 3 },  N: { value: 10, count: 7 },  O: { value: 10, count: 10 },
  P: { value: 25, count: 3 },  Q: { value: 100, count: 1 }, R: { value: 10, count: 7 },
  S: { value: 10, count: 5 },  T: { value: 10, count: 7 },  U: { value: 10, count: 6 },
  V: { value: 40, count: 2 },  W: { value: 35, count: 3 }, X: { value: 75, count: 1 },
  Y: { value: 35, count: 2 },  Z: { value: 95, count: 1 }
};


tilebag_build_master();
tilebag_build_from_master_and_shuffle();
// first draw 7
var tiles   = 10;
// --- Force the first 10 tiles to "PLACETILES"
var preset = "PLACETILES";
hand_tiles = array_create(tiles);

for (var i = 0; i < tiles; i++) {
    var ch = string_char_at(preset, i + 1);
    var letter_info = variable_struct_get(global.tile_data, ch);
    hand_tiles[i] = { letter: ch, value: letter_info.value };
}


// ui layout
var width  = display_get_gui_width();
var height = display_get_gui_height();
// layout metrics
var tile_w = 100;
var tile_h = 100;
var gap    = 5;      // 150 + 5 = your 155 step
var side_w = 300;    // confirm/reset column
var rows_h = tile_h; // Only bottom row now
var panel_width  = (tile_w + gap) * tiles + side_w; // 155*7 + 400 = 1485
var panel_height = rows_h;                          // 105
var bottom_margin = 15; // change if you want a little breathing room
var panel_x = (width  - panel_width)  div 2;                 // centered X
var panel_y = (height - panel_height) - bottom_margin;       // stuck to bottom

_panel = new UIPanel("panel", panel_x, panel_y, panel_width, panel_height, transparent);
_panel.setResizable(false)
_panel.setMovable(false)
global.tiles = [];
global.current_word_tiles = [];
scribble_font_set_default("Kreon_Tiles");

// tiles in the hand (bottom row)
for (var i = 0; i < tiles; i++) {
    var _tile = new UIButton("hand_" + string(i), (tile_w + gap) * i, 0, tile_w, tile_h, "", panel_border_015);
	_tile.setSpriteClick(panel_transparent_center_015);
	var hand_tile = hand_tiles[i];
	
	var _text = new UIText("hand_text_"+string(i), tile_w/2, tile_h/2, "[c_black]" + hand_tile.letter);
	_tile.add(_text);
	_tile._text = _text;
	_tile._letter = hand_tile.letter
	var _score = new UIText("hand_score_"+string(i), tile_w-24, tile_h-16, "[c_black][Kreon]" + string(hand_tile.value))
	_tile.add(_score)
	_tile._score = _score
	_tile._value = hand_tile.value
	
    _panel.add(_tile);
    array_push(global.tiles, _tile);
}

_confirm = new UIButton("confirm", (tile_w + gap) * tiles, 0, side_w, tile_h, "[c_black]Post", panel_border_015);
_confirm.setSpriteClick(panel_transparent_center_015);
_panel.add(_confirm);


// reset (bottom-right)
_reset = new UIButton("reset", (tile_w + gap) * tiles, 0, side_w, tile_h, "[c_black]Recycle", panel_border_015);
_reset.setSpriteClick(panel_transparent_center_015);
_panel.add(_reset);

// Add callbacks for bottom row tiles (tiles in hand)
for (var i = 0; i < tiles; i++) {
    var tile_btn = global.tiles[i];
    tile_btn.setCallback(UI_EVENT.LEFT_RELEASE, method(tile_btn, function() {
		play_letter_sound()
        // Directly place the tile in the word wall
        place_tile_directly(self._letter, self._value);
        
        // Hide and disable this bottom tile
        self.setVisible(false);
        self.setEnabled(false);
    }));
}

_confirm.setCallback(UI_EVENT.LEFT_RELEASE, method(_confirm, function() {
	// Validate the current word and start a new line
    validate_current_word();
    draw_new_tiles();
}));

// Add callback for reset button
_reset.setCallback(UI_EVENT.LEFT_RELEASE, method(_reset, function() {
	audio_play_sound(Ding, 1.0, false);
    draw_new_tiles()
}));

// reset (bottom-right)
_replay = new UIButton("replay", (tile_w + gap) * tiles, 0, side_w, tile_h, "[c_black]Retry", panel_border_015);
_replay.setSpriteClick(panel_transparent_center_015);
_replay.setVisible(false);
_panel.add(_replay);

_replay.setCallback(UI_EVENT.LEFT_RELEASE, method(_reset, function() {
	audio_play_sound(Ding, 1.0, false);
    RetryGame()
	if (crazy_started()) {
		crazy_ad_request_ad(
	    "midgame",
		    function() { show_debug_message("Ad started!"); },
		    function(err) { show_debug_message("Ad error: " + string(err)); },
		    function() { show_debug_message("Ad finished!"); }
		);			
	}
}));

// create initial word wall (valid word, so create real walls)
CreateWordWall("HELLO", 250, room_height - 300, true);
global.words_played = []

if (crazy_started()) {
	// TODO a banner here?	
}

if (crazy_started()) {
	crazy_game_loading_stop();	
}