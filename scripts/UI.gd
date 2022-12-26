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


func _ready():
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
		if count >= 8:
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


func _physics_process(delta):
	get_node('%PointsLabel').text = str(score)


func generate_blocks():
	var count = 0
	for child in $Panel/BlocksHolder.get_children():
		var rand = randi() % 5
		
		var block = load(blocks[rand]).instance()
		child.add_child(block)
		block.connect('block_deleted', self, 'on_block_delete')
		
		count += 1


# this function is responsible for checking each lines
# and if an entire line has a piece delete that whole line
func check_grid():
	for line in hor_slots:
		var b = true
		
		for slot in line:
			if slot.has_piece == false:
				b = false
				break
		
		if b == false:
			pass
		else:
			for slot in line:
				slot.clear_slot()
			score += 100
			ManagerGame.player_data['coins'] += 100
	
	for line in vert_slots:
		var b = true
		
		for slot in line:
			if slot.has_piece == false:
				b = false
				break
		
		if b == false:
			pass
		else:
			for slot in line:
				slot.clear_slot()
			score += 100
			ManagerGame.player_data['coins'] += 100


func check_grid_virtual():
	
	var lines_ok = []
	
	
	for line in hor_slots:
		var b = true
		
		for slot in line:
			if slot.has_piece == false and slot.has_piece_hover == false:
				b = false
				break
		
		if b == false:
			pass
#			for slot in line:
#				slot.highlight_slot(false)
		else:
			lines_ok.append(line)
#			for slot in line:
#				slot.highlight_slot()
	
	for line in vert_slots:
		var b = true
		
		for slot in line:
			if slot.has_piece == false and slot.has_piece_hover == false:
				b = false
				break
		
		if b == false:
			pass
#			for slot in line:
#				slot.highlight_slot(false)
		else:
			lines_ok.append(line)
#			for slot in line:
#				slot.highlight_slot()


func on_block_delete():
	check_grid()
	
	var count = 0
	
	for child in $Panel/BlocksHolder.get_children():
		if child.get_child_count() >= 1:
			count += 1
	
	# if the last block is being deleted
	# generate new ones
	if count <= 1:
		generate_blocks()


func _on_Timer_timeout():
	time_elapse_secs += 1
