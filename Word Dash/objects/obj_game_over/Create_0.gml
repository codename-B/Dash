/// obj_game_over – Create

// ===== UI layout =====
var gui_w  = display_get_gui_width();
var gui_h  = display_get_gui_height();

var tile_w = 200;
var tile_h = 200;

var panel_w   = gui_w - tile_w * 2;
var panel_h   = gui_h - tile_h * 2;
var bottom_m  = 15;
var panel_x   = (gui_w  - panel_w)  div 2;
var panel_y   = (gui_h - panel_h) - bottom_m;

var topbar_h  = 100;
var stats_h   = 110;
var side_pad  = 15;

// ===== Background =====
_background = new UIPanel("game_over_background", 0, 0, gui_w, gui_h, panel_half);
_background.setResizable(false);
_background.setMovable(false);

// ===== Main Panel =====
_panel = new UIPanel("game_over", tile_w, tile_h, panel_w, panel_h, panel);
_panel.setResizable(false);
_panel.setMovable(false);

// ===== Top bar =====
_topbar = new UIGroup("game_over_top", 0, 0, panel_w, topbar_h, panel_border_015);

var currScore = global.score_ui._value;
var currRank  = get_rank_title(currScore);

_rankTitle = new UIText("game_over_rank", panel_w * 0.5, topbar_h * 0.5, "[c_black]Rank: " + currRank);
_topbar.add(_rankTitle);

_closeButton = new UIButton("game_over_close", panel_w - 90, 10, 80, 80, "[c_white]X", panel);
_closeButton.setSpriteClick(panel_solid);
_closeButton.setCallback(UI_EVENT.LEFT_RELEASE, method(_closeButton, function () {
    audio_play_sound(Ding, 1.0, false);
    instance_destroy(obj_game_over);
}));
_topbar.add(_closeButton);

_panel.add(_topbar);

// ===== BEST STATS SECTION =====
var bestScore     = get_best_score()
var is_record     = (currScore > bestScore);
var shownBest     = is_record ? currScore : bestScore;
var shownBestRank = get_rank_title(shownBest);

show_debug_message(string(bestScore))
show_debug_message(string(shownBest))

var bestWord      = get_best_word();
var bestWordScore = get_word_score_by_word(bestWord)

var best_x = side_pad;
var best_y = topbar_h + 10;
var best_w = panel_w - (side_pad * 2);
var best_h = stats_h;

_bestSection = new UIGroup("best_section", best_x, best_y, best_w, best_h, panel_border_015);
_panel.add(_bestSection);

// Line 1: best score
var bestLine = "[c_black][Kreon_Tiles_Small]Best Score: " + string(shownBest) + "  [c_dkgray][Kreon_Tiles_Small](" + shownBestRank + ")";
if (is_record) bestLine += "  [c_red][Kreon_Tiles_Small]NEW RECORD!";

_bestScoreText = new UIText("best_score_text", best_w * 0.5, 24, bestLine);
_bestSection.add(_bestScoreText);

// Line 2: best word as tiles + score + label
var tile_size      = 44;
var tile_overlap   = -4;
var row_pad_left   = 20;
var score_pull_in  = 300;                  // pull in scores by 300px
var score_col_best = best_w - score_pull_in;

var bw_len     = string_length(bestWord);
var bw_tiles_w = (bw_len * tile_size) + max(0, bw_len - 1) * tile_overlap;
var bw_area_w  = max(0, (score_col_best - 16) - row_pad_left);
var bw_start_x = row_pad_left + max(0, (bw_area_w - bw_tiles_w) * 0.5);
var bw_base_y  = 64 - tile_size * 0.5;

var cur_x = bw_start_x;
for (var c = 1; c <= bw_len; c++) {
    var ch = string_char_at(bestWord, c);

    var tile = new UIGroup("best_tile_" + string(c), cur_x, bw_base_y, tile_size, tile_size, panel_border_015);
    _bestSection.add(tile);

    var letter = new UIText("best_tile_txt_" + string(c), cur_x + tile_size * 0.5, bw_base_y + tile_size * 0.5, "[c_black][Kreon_Tiles_Small]" + string_upper(ch));
    _bestSection.add(letter);

    cur_x += tile_size + tile_overlap;
}

// score text
var bwScoreText = new UIText("best_word_score", score_col_best, bw_base_y + tile_size * 0.5, "[c_black][Kreon_Tiles_Small]" + string(bestWordScore) + " pts");
_bestSection.add(bwScoreText);

// label "Best Word"
var bwLabel = new UIText("best_word_label", 400, bw_base_y + tile_size * 0.5, "[c_black][Kreon_Tiles_Small]Best Word");
_bestSection.add(bwLabel);

// ===== "Words Played" header =====
var wordsHeader_y = best_y + best_h + 24;
_wordsHeader = new UIText("words_header", panel_w * 0.5, wordsHeader_y, "[c_white][Kreon_Score]Best Words");
_panel.add(_wordsHeader);

// ===== Scrollable area =====
var scroll_top = wordsHeader_y + 24;
var scroll_h   = panel_h - scroll_top - 120;
var scroll_w   = panel_w - (side_pad * 2);

_scrollArea = new UIGroup("word_list_area", side_pad, scroll_top, scroll_w, scroll_h, transparent);
_scrollArea.setClipsContent(true);
_panel.add(_scrollArea);

_wordList = new UIGroup("word_list_content", 0, 0, scroll_w, 100, transparent);
_scrollArea.add(_wordList);

// ===== Total score (current run) =====
var bottom_y = panel_h - 100;
_totalScoreText = new UIText("total_score", panel_w * 0.5, bottom_y + 50, "[c_white][Kreon_Score]Total Score: " + string(currScore));
_panel.add(_totalScoreText);

// ===== Prepare and sort word list =====
var words = [];
var count = array_length(global.words_played);

for (var i = 0; i < count && i < 5; i++) {
    var w = string(global.words_played[i]);
    var s = get_word_score_by_word(w);
    array_push(words, { word: w, score: s });
}

// sort descending
array_sort(words, function(a, b) { return b.score - a.score; });

// ===== Populate scrollable word rows =====
var row_h          = 56;
var score_col_list = scroll_w - score_pull_in;

for (var i = 0; i < count; i++) {
    var word   = words[i].word;
    var wscore = words[i].score;

    var row_y  = i * row_h;
    var row    = new UIGroup("row_" + string(i), 0, row_y, scroll_w, row_h, transparent);
    _wordList.add(row);

    var len     = string_length(word);
    var tiles_w = (len * tile_size) + max(0, len - 1) * tile_overlap;
    var area_w  = max(0, (score_col_list - 16) - row_pad_left);
    var start_x = row_pad_left + max(0, (area_w - tiles_w) * 0.5);
    var base_y  = (row_h - tile_size) * 0.5;

    var cx = start_x;
    for (var c = 1; c <= len; c++) {
        var ch = string_char_at(word, c);

        var tile = new UIGroup("tile_" + string(i) + "_" + string(c), cx, base_y, tile_size, tile_size, panel_border_015);
        row.add(tile);

        var letter = new UIText("tile_txt_" + string(i) + "_" + string(c), cx + tile_size * 0.5, base_y + tile_size * 0.5, "[c_black][Kreon_Tiles_Small]" + string_upper(ch));
        row.add(letter);

        cx += tile_size + tile_overlap;
    }

    var scoreText = new UIText("word_score_" + string(i), score_col_list, base_y + tile_size * 0.5, "[c_white][Kreon_Tiles_Small]" + string(wscore) + " pts");
    row.add(scoreText);
}

// ===== Scroll globals =====
global.wordlist_content_h    = count * row_h;
global.wordlist_scroll_y     = 0;
global.wordlist_scroll_speed = 30;
global.wordlist_scroll_h     = scroll_h;

// ===== Scroll callbacks =====
_scrollArea.setCallback(UI_EVENT.MOUSE_WHEEL_UP, function () {
    var max_scroll = max(0, global.wordlist_content_h - global.wordlist_scroll_h);
    global.wordlist_scroll_y = clamp(global.wordlist_scroll_y - global.wordlist_scroll_speed, 0, max_scroll);
    _wordList.y = -global.wordlist_scroll_y;
});

_scrollArea.setCallback(UI_EVENT.MOUSE_WHEEL_DOWN, function () {
    var max_scroll = max(0, global.wordlist_content_h - global.wordlist_scroll_h);
    global.wordlist_scroll_y = clamp(global.wordlist_scroll_y + global.wordlist_scroll_speed, 0, max_scroll);
    _wordList.y = -global.wordlist_scroll_y;
});