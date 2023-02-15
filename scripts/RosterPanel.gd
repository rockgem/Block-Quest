extends Panel


func _ready():
	for id in ManagerGame.rosters_data:
		var display = load("res://actors/Card.tscn").instance()
		display.char_id = id
		
		get_node('%RostersList').add_child(display)


func refresh_rosters_availability():
	for card in get_node('%RostersList').get_children():
		card.set_status(true)
	
	var temp = []
	
	for card in get_node('%RostersList').get_children():
		for roster in ManagerGame.data['rosters']:
			if roster['id'] == card.char_id:
				temp.append(card)
	
	for card in temp:
		card.set_status(false)
