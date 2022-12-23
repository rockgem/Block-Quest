extends Panel



var has_piece: bool = false
var has_piece_hover: bool = false


var bg_color = '#8e00a5'
var bg_green = '#b4ffb3'


func occupy_slot():
	has_piece = true
	$Icon.show()
	
	change_bg_to_default()


func clear_slot():
	has_piece = false
	$Icon.hide()


func highlight_slot(b: bool = true):
	if b:
		$BackFX.show()
	else:
		$BackFX.hide()


func change_bg_color():
	self_modulate = Color(bg_green)


func change_bg_to_default():
	self_modulate = Color(bg_color)






