extends Panel


func _ready():
	
	for card in get_node('%RostersList').get_children():
		card.set_status(true)
	
	var temp = []
	
	for card in get_node('%RostersList').get_children():
		for roster in ManagerGame.data['rosters']:
			if roster['id'] == card.char_id:
				temp.append(card)
	
	for card in temp:
		card.set_status(false)
	
	
#	for hero in ManagerGame.rosters_data.keys():
#		var display = load("res://actors/RosterDisplay.tscn").instance()
#		display.texture = load("res://reso/heroes/%s.png" % hero)
#		get_node('%List').add_child(display)
