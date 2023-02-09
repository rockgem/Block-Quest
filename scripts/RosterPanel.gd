extends Panel


func _ready():
	return
	for hero in ManagerGame.rosters_data.keys():
		var display = load("res://actors/RosterDisplay.tscn").instance()
		display.texture = load("res://reso/heroes/%s.png" % hero)
		get_node('%List').add_child(display)
