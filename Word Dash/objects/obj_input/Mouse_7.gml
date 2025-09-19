var _scale = UI.getScale(); // Get the UI's global scale
var _scaled_x = mouse_gui_x() / _scale;
var _scaled_y = mouse_gui_y() / _scale;
var _all_widgets = ui_get_widgets();
for (var i = array_length(_all_widgets) - 1; i >= 0; i--) {
    var _widget = _all_widgets[i];
    
    // Check if widget is active and mouse is inside its bounds
    if (_widget.__visible && _widget.__enabled) {
		var _widget_x1 = _widget.getX();
	    var _widget_y1 = _widget.getY();
	    var _widget_x2 = _widget_x1 + _widget.getWidth();
	    var _widget_y2 = _widget_y1 + _widget.getHeight();
    
	    // Perform a point-in-rectangle check
	    var _is_over = (_scaled_x >= _widget_x1 && _scaled_x < _widget_x2 &&
	                    _scaled_y >= _widget_y1 && _scaled_y < _widget_y2);
		
		// Fire the event manually
		if (_is_over) {
			_widget.__events_fired[UI_EVENT.LEFT_RELEASE] = true
		}
	}
}