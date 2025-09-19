if (global.game_running) {
    if (!instance_exists(obj_tile_parent)) {
        var _player = instance_find(obj_player, 0);
        if (instance_exists(_player) && _player.state != PLAYERSTATE.DEAD) {
            
            // Set the player's state to DEAD. The player object will handle the rest.
            _player.state = PLAYERSTATE.DEAD;
            global.game_running = false;
			array_push(global.scores, global.score_ui._value)
			
			var sounds = [death1, death2, death3, death4, death5, death6, death7, death8, death9, death10, death11]
			audio_play_sound(sounds[random(array_length(sounds))], 1.0, false);
            
            show_debug_message("PLAYER IS DEAD - NO TILES LEFT");
			
			// Hide all tiles first
			for(var i=0; i<array_length(global.tiles); i++) {
				var tile = global.tiles[i];
				tile.setVisible(false);
			}
			
			// Show "YOU DIED" message using bottom tiles
			var y1 = global.tiles[0]
			var o = global.tiles[1]
			var u = global.tiles[2]
			
			var d1 = global.tiles[3]
			var i = global.tiles[4]
			var e = global.tiles[5]
			var d2 = global.tiles[6]
			
			y1.setEnabled(false)
			y1.setVisible(true)
			y1._text.setText("[c_black]Y")
			o.setEnabled(false)
			o.setVisible(true)
			o._text.setText("[c_black]O")
			u.setEnabled(false)
			u.setVisible(true)
			u._text.setText("[c_black]U")
			
			d1.setEnabled(false)
			d1.setVisible(true)
			d1._text.setText("[c_black]D")
			i.setEnabled(false)
			i.setVisible(true)
			i._text.setText("[c_black]I")
			e.setEnabled(false)
			e.setVisible(true)
			e._text.setText("[c_black]E")
			d2.setEnabled(false)
			d2.setVisible(true)
			d2._text.setText("[c_black]D")
			
			_confirm.setVisible(false)
			_reset.setVisible(false)
			_replay.setVisible(true)
			
			// if crazy - then we hook in the score
			if (crazy_started()) {
				crazy_game_gameplay_stop()
			}
        }
    }
}