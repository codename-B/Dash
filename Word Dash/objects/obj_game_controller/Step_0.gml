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
			for(var i=0; i<array_length(global.tiles_to_play); i++) {
				var tile = global.tiles_to_play[i];
				tile.setVisible(false);
			}
			for(var i=0; i<array_length(global.tiles); i++) {
				var tile = global.tiles[i];
				tile.setVisible(false);
			}
			
			var yy = global.tiles_to_play[3]
			var oy = global.tiles_to_play[4]
			var uy = global.tiles_to_play[5]
			
			var d = global.tiles[2]
			var iy = global.tiles[3]
			var ey = global.tiles[4]
			var dy = global.tiles[5]
			
			yy.setVisible(true)
			yy._text.setText("[c_black]Y")
			oy.setVisible(true)
			oy._text.setText("[c_black]O")
			uy.setVisible(true)
			uy._text.setText("[c_black]U")
			
			d.setEnabled(false)
			d.setVisible(true)
			d._text.setText("[c_black]D")
			iy.setEnabled(false)
			iy.setVisible(true)
			iy._text.setText("[c_black]I")
			ey.setEnabled(false)
			ey.setVisible(true)
			ey._text.setText("[c_black]E")
			dy.setEnabled(false)
			dy.setVisible(true)
			dy._text.setText("[c_black]D")
			
			_confirm.setVisible(false)
			_reset.setVisible(false)
			_replay.setVisible(false)
			
			// if crazy - then we hook in the score
			if (crazy_started()) {
				crazy_game_gameplay_stop()
			}
        }
    }
}