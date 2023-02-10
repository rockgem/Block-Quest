extends Panel

export(int) var price = 1000



func _ready():
	$Price.text = str(price)
	
	$TextureRect.rect_pivot_offset = $TextureRect.rect_size / 2
	$Tween.interpolate_property($TextureRect, 'rect_scale:x', 1.0, 1.2, 1.0, Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Tween.interpolate_property($TextureRect, 'rect_scale:x', 1.2, 1.0, 1.0, Tween.TRANS_LINEAR,Tween.EASE_OUT, 1.0)
	$Tween.interpolate_property($TextureRect, 'rect_scale:y', 1.0, 0.8, 1.0, Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Tween.interpolate_property($TextureRect, 'rect_scale:y', 0.8, 1.0, 1.0, Tween.TRANS_LINEAR,Tween.EASE_OUT, 1.0)
	$Tween.start()




func _on_Buy_pressed():
	
	ManagerGame.data['gold'] -= price
	
	var rand = int(rand_range(0, ManagerGame.rosters_data.size()-1))
	var rand_id = ManagerGame.rosters_data.keys()[rand]
	var data: Dictionary = ManagerGame.rosters_data[rand_id]
	
	var found = false
	for dict in ManagerGame.data['rosters']:
		if dict['id'] == rand_id:
			var r_exp = int(rand_range(2, 10))
			dict['exp'] += r_exp
			found = true
			break
	
	if found == false:
		var new_roster: Dictionary = data.duplicate()
		new_roster['level'] = 1
		new_roster['exp'] = 0
		ManagerGame.data['rosters'].append(new_roster)
	
	
	
	ManagerGame.emit_signal("chest_buy", data)
	ManagerGame.emit_signal("coins_changed")
