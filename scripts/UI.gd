extends Control


var blocks = [
	"res://actors/blocks/Block1.tscn",
	"res://actors/blocks/Block3.tscn",
	"res://actors/blocks/Block6.tscn",
	"res://actors/blocks/Block9.tscn",
	"res://actors/blocks/Block4.tscn",
]

onready var slots = $CenterContainer/Slots.get_children()

var hor_slots = []
var vert_slots = []


var time_elapse_secs: int = 0
var score: int = 0


var virtual_lines_ref = []

func _ready():
	ManagerGame.connect("line_deleted", self, 'on_line_deleted')
	
	_on_Timer_timeout()
	randomize()
	
	for child in $Panel/BlocksHolder.get_children():
		child.rect_pivot_offset = child.rect_size / 2
	
	generate_blocks()
	
	
	# assigning vertical and horizontal ---------
	
	# horizontal side
	var count = 0
	var new_arr = []
	for slot in slots:
		new_arr.append(slot)
		
		count += 1
		if count >= 9:
			var temp = new_arr.duplicate()
			hor_slots.append(temp)
			new_arr.clear()
			count = 0
	
	
	# vertical side
	var col = 0
	for arr in hor_slots:
		var temp = []
		
		for j in hor_slots.size():
			var s = hor_slots[j][col]
			temp.append(s)
		
#		if col % 2 == 0:
#			for slot in temp:
#				slot.change_bg_color()
		
		col += 1
		
		vert_slots.append(temp)
	# ------------------------------------------


#func _physics_process(delta):
#	check_grid_virtual()


func _process(delta):
	check_grid_virtual()


func _physics_process(delta):
	get_node('%PointsLabel').text = str(score)


func pop_dialog(message: String = ''):
	if message == '':
		ManagerGame.speech.shuffle()
		message = ManagerGame.speech[0]
	
	var tween = get_tree().create_tween()
	tween.tween_property($Dialog, 'rect_position:x', 25.0, 0.3).set_trans(Tween.TRANS_BOUNCE)
	
	$Dialog/Label.percent_visible = 0.0
	$Dialog/Label.text = message
	$Dialog/DialogTimer.start()


# generates 3 new random blocks
func generate_blocks():
	var count = 0
	for child in $Panel/BlocksHolder.get_children():
		var rand = randi() % 5
		
		var block = load(blocks[rand]).instance()
#		var block = load(blocks[0]).instance()
		child.add_child(block)
		block.connect('block_deleted', self, 'on_block_delete')
		
		count += 1


# this function is responsible for checking each lines
# and if an entire line has a piece delete that whole line
func check_grid():
	
	# this stores the lines that are eligible for deletion
	# we store them first so that we can delete from both vertical
	# and horizontal when necessary
	var lines_ok = []
	# --------------------------------------------------------
	
	for line in hor_slots:
		var b = true
		
		for slot in line:
			if slot.has_piece == false:
				b = false
				break
		
		if b == false:
			pass
		else:
			lines_ok.append(line)
	
	for line in vert_slots:
		var b = true
		
		for slot in line:
			if slot.has_piece == false:
				b = false
				break
		
		if b == false:
			pass
		else:
			lines_ok.append(line)
	
	if lines_ok.empty() == false:
		for line in lines_ok:
			for slot in line:
				slot.clear_slot()
		
		ManagerGame.emit_signal("line_deleted")
		pop_dialog()


func check_grid_virtual():
	for slot in slots:
		slot.highlight_slot(false)
	
	for line in hor_slots:
		var b = true
		
		for slot in line:
			if slot.has_piece == false and slot.has_piece_hover == false:
				b = false
				break
		
		if b:
			if virtual_lines_ref.has(line) == false:
				virtual_lines_ref.append(line)
		else:
			virtual_lines_ref.erase(line)
	
	for line in vert_slots:
		var b = true
		
		for slot in line:
			if slot.has_piece == false and slot.has_piece_hover == false:
				b = false
				break
		
		if b:
			if virtual_lines_ref.has(line) == false:
				virtual_lines_ref.append(line)
		else:
			virtual_lines_ref.erase(line)
	
	if virtual_lines_ref.empty() == false:
		for line in virtual_lines_ref:
			for slot in line:
				slot.highlight_slot()


func on_block_delete():
	virtual_lines_ref.clear()
	
	for child in slots:
		child.change_bg_to_default()
	
	$"/root/Sfx".get_node("Pop2").play()
	check_grid()
	
	var count = 0
	
	for child in $Panel/BlocksHolder.get_children():
		if child.get_child_count() >= 1:
			count += 1
	
	# if the last block is being deleted
	# generate new ones
	if count <= 1:
		generate_blocks()


func on_line_deleted():
	$Burst.emitting = true
	score += 100
	ManagerGame.data['gold'] += 100
	
	var task: FirestoreTask = ManagerGame.firestore_collection.update(Firebase.Auth.auth['localid'], ManagerGame.data)
	


func _on_Timer_timeout():
	time_elapse_secs += 1
	$Time/TimeLabel.text = ManagerGame.secs_to_mins(time_elapse_secs)


func _on_Home_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")


func _on_DialogTimer_timeout():
	$Dialog/Label.visible_characters += 1
	
	if $Dialog/Label.percent_visible >= 1.0:
		$Dialog/DialogTimer.stop()
		yield(get_tree().create_timer(2.0), "timeout")
		var tween = get_tree().create_tween()
		tween.tween_property($Dialog, 'rect_position:x', $Dialog.rect_position.x - 750.0, 0.3).set_trans(Tween.TRANS_BOUNCE)
