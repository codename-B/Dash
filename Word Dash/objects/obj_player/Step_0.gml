// --- State Machine ---
walk_speed += 0.001
switch (state) {
    case PLAYERSTATE.DEAD:
        // This check ensures we only set the sprite once when entering the state
        if (sprite_index != spr_player_death) {
            sprite_index = spr_player_death;
            image_index = 0; // Start animation from the beginning
            image_speed = 1; 
        }
        
        h_scroll = 0; // Stop the world
        vsp += gravity_force; // Let the player fall
        // --- FIX: STOP ANIMATION ON LAST FRAME ---
        // image_number is the total number of frames in the sprite
        if (image_index >= image_number - 1 && image_speed != 0) {
            image_speed = 0;
			// game over screen
			instance_create_layer(0, 0, "Instances", obj_game_over)
        }
        break;
        

    case PLAYERSTATE.IDLE:
        // ... (no changes needed) ...
        sprite_index = spr_player_idle;
        h_scroll = 0;
        if (global.game_running) {
            state = PLAYERSTATE.WALKING;
        }
        break;

    case PLAYERSTATE.WALKING:
        sprite_index = spr_player_walk;
        image_speed = walk_speed / 8;
        h_scroll = walk_speed;

        // --- BOUNDING BOX AUTO-JUMP LOGIC ---
        
        // 1. First, confirm we are on the ground by checking a thin line just below our feet.
        // We shrink the check horizontally by 1 pixel on each side to avoid snagging on adjacent tile edges.
        var _on_ground = collision_rectangle(bbox_left + 1, bbox_bottom, bbox_right - 1, bbox_bottom + 1, obj_tile_parent, false, true);

        if (_on_ground) {
            // 2. Now, look ahead from our front foot to see if there's a gap.
            // This is our "whisker" that feels for the edge.
            var _lookahead_dist = 64; // Tweak this value for jump timing!

            var _gap_ahead = !collision_rectangle(bbox_right, bbox_bottom, bbox_right + _lookahead_dist, bbox_bottom + 1, obj_tile_parent, false, true);
            
            if (_gap_ahead) {
                state = PLAYERSTATE.PREJUMP;
            }
        }
        break;
        
    case PLAYERSTATE.PREJUMP:
        // This is the 2-frame lead-in animation.
        if (sprite_index != spr_player_jump) {
            sprite_index = spr_player_jump;
            image_index = 0;
            image_speed = 1;
        }
        
        h_scroll = walk_speed; // Keep scrolling during wind-up
        
        // After the first 2 frames (index 0, 1) are done...
        if (image_index >= 2) {
            vsp = -jump_force;       // ...actually jump...
            state = PLAYERSTATE.JUMPING; // ...and switch to the mid-air state.
        }
        break;
        
    case PLAYERSTATE.JUMPING:
        // This is the mid-air hold frame.
        sprite_index = spr_player_jump;
        image_index = 2; // Set to the 3rd frame (index 2)
        image_speed = 0; // Freeze on this frame
        
        h_scroll = walk_speed;
        
        // Check if we are about to land
        if (vsp > 0 && place_meeting(x, y + 1, obj_wall)) {
            state = PLAYERSTATE.LANDING;
        }
        break;
        
    case PLAYERSTATE.LANDING:
        // This is the 2-frame landing animation.
		if (image_index == 2) {
			image_index = 3; // Start at the 4th frame (index 3)
			image_speed = 1;
		}
        
        h_scroll = walk_speed; // Keep scrolling while landing
        
        // Once the landing animation finishes...
        if (image_index >= image_number - 1) {
            state = PLAYERSTATE.WALKING; // ...go back to walking.
        }
        break;
}

// Universal Physics (runs for all non-dead states)
if (state != PLAYERSTATE.DEAD) {
    var on_ground = place_meeting(x, y + 1, obj_wall); // Fixed: using obj_wall consistently
    if (!on_ground) {
        vsp += gravity_force;
    } else {
        // Only reset vsp if we are actually in a state that should be on the ground
        if (state != PLAYERSTATE.JUMPING && state != PLAYERSTATE.PREJUMP) {
             vsp = 0;
        }
    }
}

// Update the scroll variables for tiles to read
v_scroll = vsp;