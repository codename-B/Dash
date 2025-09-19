/// ======================================================
/// ONE-TIME INDEX BUILD (run once after loading global.wordlist)
/// Builds: global.word_index_3to5 where keys are sorted-letter signatures
/// (e.g., "ACT") and values are arrays of uppercase words sharing that signature.
/// ======================================================
function build_word_index_3to5() {
    global.word_index_3to5 = {};
    var keys = variable_struct_get_names(global.wordlist); // words are keys (ideally uppercase)
    var n = array_length(keys);

    for (var i = 0; i < n; i++) {
        var w = string_upper(keys[i]);              // ensure uppercase
        var L = string_length(w);
        if (L < 3 || L > 5) continue;

        var key = __sorted_signature_from_word(w);  // e.g., "TCA" -> "ACT"

        // fetch or create bucket (2-arg API + exists check)
        var bucket = undefined;
        if (variable_struct_exists(global.word_index_3to5, key)) {
            bucket = variable_struct_get(global.word_index_3to5, key);
            array_push(bucket, w);
            variable_struct_set(global.word_index_3to5, key, bucket);
        } else {
            bucket = [ w ];
            variable_struct_set(global.word_index_3to5, key, bucket);
        }
    }
}

/// For a short word (3..5), return alphabetically sorted signature using counting (fast)
function __sorted_signature_from_word(w) {
    var L = string_length(w);
    var cnt = array_create(26, 0);
    for (var i = 1; i <= L; i++) {
        var c = string_byte_at(w, i) - 65; // 'A'..'Z'
        if (c >= 0 && c < 26) cnt[c] += 1;
    }
    var s = "";
    for (var a = 0; a < 26; a++) if (cnt[a] > 0) s += string_repeat(chr(65 + a), cnt[a]);
    return s;
}

/// ======================================================
/// DRAW + SEARCH (3..5 letters; skip if <3 tiles)
/// ======================================================
function draw_tiles(count) {
    var tiles = [];

    // draw tiles (keep structs intact; do not uppercase their fields)
    for (var i = 0; i < count; i++) {
        if (array_length(global.expedition_tile_bag) == 0) {
            tilebag_build_from_master_and_shuffle();
        }
        var t = array_pop(global.expedition_tile_bag);
        if (!is_undefined(t)) array_push(tiles, t);
    }

    // if fewer than 3 tiles, no search — just shuffle and return
    if (array_length(tiles) < 3) {
        return array_shuffle(tiles);
    }

    // try 5 → 4 → 3 (randomized combinations)
    var word = __pick_word_via_sorted_index(tiles, 5);
    if (is_undefined(word)) word = __pick_word_via_sorted_index(tiles, 4);
    if (is_undefined(word)) word = __pick_word_via_sorted_index(tiles, 3);

    if (!is_undefined(word)) {
        tiles = __embed_word_centered(word, tiles); // NEW: word always centered
    } else {
        tiles = array_shuffle(tiles);
    }

    return tiles;
}

/// Generate all combinations of size K from tiles (random order),
/// build the sorted signature for each, and look up in global.word_index_3to5.
/// Returns a random matching word (UPPERCASE) or undefined.
function __pick_word_via_sorted_index(tiles, K) {
    var n = array_length(tiles);
    if (K < 3 || K > 5 || n < K) return undefined;

    // build array of indices [0..n-1]
    var idx = [];
    for (var i = 0; i < n; i++) array_push(idx, i);

    // prebuild K-combinations, then shuffle for randomness
    var combos = __all_combinations(idx, K);
    combos = array_shuffle(combos);

    for (var c = 0; c < array_length(combos); c++) {
        var key = __signature_from_tile_indices(tiles, combos[c]); // e.g., "ABC.."
        if (variable_struct_exists(global.word_index_3to5, key)) {
            var bucket = variable_struct_get(global.word_index_3to5, key);
            if (is_array(bucket) && array_length(bucket) > 0) {
                return bucket[ irandom(array_length(bucket) - 1) ];
            }
        }
    }

    return undefined;
}

/// Return a sorted-letter signature for chosen tile indices (case-insensitive on tile.letter).
/// Uses 26-bin counting for speed.
function __signature_from_tile_indices(tiles, indices_array) {
    var cnt = array_create(26, 0);
    var m = array_length(indices_array);

    for (var i = 0; i < m; i++) {
        var tile = tiles[ indices_array[i] ];
        var ch = string_byte_at(string_upper(tile.letter), 1) - 65; // 'A'..'Z'
        if (ch >= 0 && ch < 26) cnt[ch] += 1;
    }

    var s = "";
    for (var a = 0; a < 26; a++) if (cnt[a] > 0) s += string_repeat(chr(65 + a), cnt[a]);
    return s;
}

/// Generate all K-combinations (no repetition) from an array (returns array of arrays of indices).
function __all_combinations(arr, K) {
    var n = array_length(arr);
    var out = [];

    if (K == 3) {
        for (var i = 0; i < n - 2; i++) {
            for (var j = i + 1; j < n - 1; j++) {
                for (var k = j + 1; k < n; k++) {
                    array_push(out, [arr[i], arr[j], arr[k]]);
                }
            }
        }
        return out;
    }

    if (K == 4) {
        for (var i = 0; i < n - 3; i++) {
            for (var j = i + 1; j < n - 2; j++) {
                for (var k = j + 1; k < n - 1; k++) {
                    for (var l = k + 1; l < n; l++) {
                        array_push(out, [arr[i], arr[j], arr[k], arr[l]]);
                    }
                }
            }
        }
        return out;
    }

    if (K == 5) {
        for (var i = 0; i < n - 4; i++) {
            for (var j = i + 1; j < n - 3; j++) {
                for (var k = j + 1; k < n - 2; k++) {
                    for (var l = k + 1; l < n - 1; l++) {
                        for (var m = l + 1; m < n; m++) {
                            array_push(out, [arr[i], arr[j], arr[k], arr[l], arr[m]]);
                        }
                    }
                }
            }
        }
        return out;
    }

    return out; // other K not used here
}

/// Remove the actual tile objects that match `word` (UPPERCASE), then center the word.
/// Remaining tiles are shuffled, then alternated to the beginning and end so the word stays centered.
function __embed_word_centered(word, tiles) {
    var remaining = tiles;
    var wl = string_length(word);

    // collect the exact tile objects for the word, in order
    var word_tiles = [];
    for (var i = 1; i <= wl; i++) {
        var need = string_char_at(word, i); // UPPERCASE
        for (var j = 0; j < array_length(remaining); j++) {
            if (string_upper(remaining[j].letter) == need) {
                array_push(word_tiles, remaining[j]);
                array_delete(remaining, j, 1);
                break;
            }
        }
    }

    // shuffle leftover tiles
    remaining = array_shuffle(remaining);

    // distribute alternately to "beginning" (left) then "end" (right)
    var left = [];
    var right = [];
    var place_left = true;
    for (var r = 0; r < array_length(remaining); r++) {
        if (place_left) array_push(left, remaining[r]); else array_push(right, remaining[r]);
        place_left = !place_left;
    }

    // When adding to the beginning repeatedly, earlier items end up nearer to the word.
    // To emulate that with concatenation, reverse the left chunk.
    left = array_reverse(left);

    // Build final: left + word_tiles + right
    var out = [];

    for (var i = 0; i < array_length(left); i++)  array_push(out, left[i]);
    for (var k = 0; k < array_length(word_tiles); k++) array_push(out, word_tiles[k]);
    for (var j = 0; j < array_length(right); j++) array_push(out, right[j]);

    return out;
}
