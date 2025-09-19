/**
 * Draws a specified number of tiles from the expedition tile bag
 * 
 * This function removes tiles from the global expedition tile bag and returns them
 * in an array. If the bag becomes empty during drawing, it automatically rebuilds
 * and shuffles the bag from the master tile collection to ensure continuous play.
 * 
 * @param {real} count - The number of tiles to draw from the bag
 * @return {array} An array containing the drawn tiles
 * 
 * @example
 * // Draw 5 tiles for player's hand
 * var player_tiles = draw_tiles(5);
 * 
 * @example
 * // Draw a single tile
 * var single_tile = draw_tiles(1);
 * 
 * @note Requires global.expedition_tile_bag to be initialized
 * @note Calls tilebag_build_from_master_and_shuffle() when bag is empty
 */
function draw_tiles(count) {
    // Initialize array to store drawn tiles
    var tiles = [];
    
    // Draw the requested number of tiles
    for (var i = 0; i < count; i++) {
        // Check if expedition bag is empty
        if (array_length(global.expedition_tile_bag) == 0) {
            // Rebuild and shuffle the tile bag from master collection
            tilebag_build_from_master_and_shuffle();
        }
        
        // Remove and get the last tile from the bag
        var tile = array_pop(global.expedition_tile_bag);
        
        // Add tile to result array if it exists
        if (tile != undefined) {
            array_push(tiles, tile);
        }
    }
    
    return tiles;
}