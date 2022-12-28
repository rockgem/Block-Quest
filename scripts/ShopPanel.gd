extends Panel



func _ready():
	randomize()
	
	ManagerGame.connect("coins_changed", self, 'on_coins_changed')
	
	for child in $Boxes.get_children():
		child.connect('clicked', self, 'on_box_clicked')
	
	get_node('%Card').rect_pivot_offset = get_node('%Card').rect_size / 2


# this returns a random hero_id to act as the choosen item that were unboxed
func buy_box(heroes_arr: Dictionary) -> String:
	var rand = randi() % 100
	var eligible = []
	var lowest = {}
	
	for hero in heroes_arr.keys():
		if heroes_arr[hero]['rarity'] <= rand:
			eligible.append(hero)
	
	var hero_gained = 'hero1'
	if eligible.size() > 1:
		eligible.shuffle()
		hero_gained = eligible[0]
	
	return hero_gained


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
		
		var hero_id = buy_box(heroes_data)
		if hero_id != '':
			var data = heroes_data[hero_id]
			if data.empty() == false:
				get_node('%CardShowerControl').show()
				var tween = get_tree().create_tween()
				tween.tween_property(get_node('%Card'), 'rect_rotation', 360.0, 0.2)
				get_node('%Card').get_node("Icon").texture = load("res://reso/heroes/%s.png" % hero_id)
				get_node('%Card').get_node("Name").text = data['name']
				get_node('%Card').get_node("Rarity").text = ManagerGame.tiers[int(data['tier'])]
				
				ManagerGame.player_data['coins'] -= price
				ManagerGame.emit_signal("coins_changed")
				
				ManagerGame.player_data['roster'][hero_id] = data
		else:
			$"/root/Sfx".get_node("Error")
	else:
		$"/root/Sfx".get_node("Error").play()


func on_coins_changed():
	$Coins/Label.text = str(ManagerGame.player_data['coins'])


func _on_ShopPanel_hide():
	get_node('%CardShowerControl').hide()


func _on_CloseCard_pressed():
	get_node('%CardShowerControl').hide()
