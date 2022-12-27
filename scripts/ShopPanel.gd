extends Panel



func _ready():
	ManagerGame.connect("coins_changed", self, 'on_coins_changed')
	
	for child in $Boxes.get_children():
		child.connect('clicked', self, 'on_box_clicked')


func on_box_clicked(price: int, ids: Array):
	if ManagerGame.player_data['coins'] >= price:
		var heroes_data = {}
		var h = {}
		
		var f = File.new()
		f.open('res://reso/heroes/heroes.json', f.READ)
		h = parse_json(f.get_as_text())
		f.close()
		
		for id in ids:
			heroes_data[id] = h.get(id)
		
		ManagerGame.player_data['coins'] -= price
		
		ManagerGame.emit_signal("coins_changed")


func on_coins_changed():
	$Coins/Label.text = str(ManagerGame.player_data['coins'])
