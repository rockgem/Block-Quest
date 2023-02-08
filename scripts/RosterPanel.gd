extends Panel


func _ready():
	for hero in ManagerGame.data['rosters'].keys():
		var display = load("res://actors/RosterDisplay.tscn").instance()
		display.texture = load("res://reso/heroes/%s.png" % hero)
		get_node('%List').add_child(display)
