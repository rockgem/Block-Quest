extends TextureRect



var is_on_empty_slot: bool = false

var area_ref = null




func put_on_slot():
	area_ref.occupy_slot()


func _on_Area2D_area_entered(area):
	if area.get_parent().has_piece == false:
		is_on_empty_slot = true
	else:
		is_on_empty_slot = false
	
	area_ref = area.get_parent()
	if area_ref.has_piece == false:
		area_ref.has_piece_hover = true


func _on_Area2D_area_exited(area):
	is_on_empty_slot = false
	
	area_ref.has_piece_hover = false
	area_ref.change_bg_to_default()
