function print (_format, _arg_array){
	var _str
	
	if is_array(_arg_array) {
		_str = string_ext(_format, _arg_array)
	}
	else if !is_undefined(_arg_array) {
		_str = string_ext(_format, [_arg_array])
	}
	else {
		_str = string(_format)
	}
	
	show_debug_message("{0} — {1}", current_time, _str)
}

function print_log(_format, _arg_array) {
	print (_format, _arg_array)
}

function print_break(){
	show_debug_message("")
}