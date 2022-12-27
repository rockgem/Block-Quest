extends Control

signal block_deleted





var is_dragging = false
var is_droppable = false


func _ready():
	rect_pivot_offset = rect_size / 2


func _process(delta):
	if is_dragging == false:
		rect_scale = Vector2(.5, .5)
	
	if is_dragging:
		rect_scale = Vector2.ONE
		
		check_pieces_for_available()


func _physics_process(delta):
	if is_dragging:
		rect_global_position = get_global_mouse_position() - (rect_size / 2)


func check_pieces() -> bool:
	for piece in get_children():
		if piece.is_on_empty_slot == false:
			return false
	
	for piece in get_children():
		piece.put_on_slot()
	
	return true


func check_pieces_for_available():
	for piece in get_children():
		if piece.is_on_empty_slot == false:
			return false
	
	for piece in get_children():
		piece.area_ref.change_bg_color()
		piece.area_ref.has_piece_hover = true


func _on_Block_gui_input(event):
	if event is InputEventScreenDrag and is_dragging == false:
		is_dragging = true
	
	if event is InputEventScreenTouch and !event.pressed and is_dragging:
		is_dragging = false
		
		if check_pieces():
			set_process(false)
			print('all pieces on empty slot put all')
			emit_signal("block_deleted")
			queue_free()
		else:
			# puts the block to the center of original position
			get_parent().queue_sort()
			$"/root/Sfx".get_node('Error').play()
			# -------------------------------------------------
			print('one or more piece on an occupied slot return block')
