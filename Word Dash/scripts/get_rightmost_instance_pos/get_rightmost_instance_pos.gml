/// @function           get_rightmost_instance_pos(object)
/// @param {Asset.GMObject} object    The object to search for (e.g., obj_wall).
/// @description        Finds the instance of a given object with the highest x-coordinate and returns its position.
/// @returns {struct | undefined} A struct with {x, y} coordinates, or undefined if no instance is found.

function get_rightmost_instance_pos(_obj) {
    var _max_x = -infinity;
    var _rightmost_inst = noone;

    // Loop through all instances of the specified object
    with (_obj) {
        // Use bbox_right to get the right edge, which is more accurate
        // for sprites with origins that aren't top-left.
        if (bbox_right > _max_x) {
            _max_x = bbox_right;
            _rightmost_inst = id;
        }
    }

    // If an instance was found, return its position
    if (_rightmost_inst != noone) {
        return {
            x: _rightmost_inst.x,
            y: _rightmost_inst.y,
			bbox_right: _rightmost_inst.bbox_right
        };
    }

    // Return undefined if no instances of the object exist
    return undefined;
}