/// scr_tilebag.gml
/// Utilities to build, shuffle, and draw from the tile bag.

/// tilebag_build_master()
/// Builds global.master_tile_collection from global.tile_data
function tilebag_build_master() {
    // Get all letter keys from the tile_data struct
    var letters = variable_struct_get_names(global.tile_data);

    // For each letter, push {letter, value} 'count' times
    for (var k = 0; k < array_length(letters); k++) {
        var letter = letters[k];
        var data = variable_struct_get(global.tile_data, letter);

        var value = data.value;
        var count = data.count;

        for (var i = 0; i < count; i++) {
            array_push(global.master_tile_collection, { letter: letter, value: value });
        }
    }
}

/// tilebag_build_from_master_and_shuffle()
/// Copies master to expedition bag and shuffles it
function tilebag_build_from_master_and_shuffle() {
    var len = array_length(global.master_tile_collection);
    if (len > 0) {
        array_copy(global.expedition_tile_bag, 0, global.master_tile_collection, 0, len);
    }
    tilebag_shuffle();
}

/// tilebag_shuffle()
/// Fisher–Yates shuffle of global.expedition_tile_bag
function tilebag_shuffle() {
	global.expedition_tile_bag = array_shuffle(global.expedition_tile_bag)
}

/// draw_tiles(count)
/// Returns an array of tiles and removes them from the expedition bag
function draw_tiles(count) {
	var tiles = [];
	
	for(var i=0; i<count; i++) {
		if (array_length(global.expedition_tile_bag) == 0) {
			tilebag_build_from_master_and_shuffle() // infinite looping!	
		}
		var tile = array_pop(global.expedition_tile_bag);
		if (tile != undefined) {
			array_push(tiles, tile);	
		}
	}

    return tiles;
}
