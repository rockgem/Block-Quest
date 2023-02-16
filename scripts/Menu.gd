extends Control





func _ready():
	ManagerGame.connect("coins_changed", self, 'on_coins_changed')
	ManagerGame.connect("chest_buy", self, 'on_chest_buy')
	
	Firebase.Auth.connect("userdata_received", self, 'on_userdata_received')
	Firebase.Auth.get_user_data()
	
	get_node('%Tab').current_tab = 4


func on_userdata_received(userdata):
	$LoggedinUserId.text = userdata.local_id
	
	
	ManagerGame.firestore_collection.get(userdata['local_id'])
	var document : FirestoreDocument = yield(ManagerGame.firestore_collection, "get_document")
	
	ManagerGame.data = document.doc_fields
	
	get_node('%Level').text = str(ManagerGame.data['level'])
	get_node('%Gold').text = str(ManagerGame.data['gold'])
	get_node('%EXP').text = str(ManagerGame.data['exp'])
	
	get_node('%Tab').get_node("Deck/DeckBuilder").load_deck()
	get_node('%Tab').get_node("Roster/Gallery").refresh_rosters_availability()
	
	
#	$Coins/Label.text = str(ManagerGame.data['gold'])
#	$ShopPanel/Coins/Label.text = str(ManagerGame.data['gold'])


func on_coins_changed():
	get_node('%Gold').text = str(ManagerGame.data['gold'])


func on_chest_buy(data):
	$Tab/Shop/ColorRect.show()
	$Tab/Shop/ColorRect/LoadingIndicator.show()
	$Tab/Shop/ColorRect/LoadingIndicator/AnimationPlayer.play("anim")
	var up_task : FirestoreTask = ManagerGame.firestore_collection.update(Firebase.Auth.auth['localid'], ManagerGame.data)
	var document : FirestoreDocument = yield(up_task, "update_document")
	ManagerGame.data = document.doc_fields
	get_node('%ShopPanel').pop(data)
	$Tab/Shop/ColorRect.hide()
	$Tab/Shop/ColorRect/LoadingIndicator.hide()
	$Tab/Shop/ColorRect/LoadingIndicator/AnimationPlayer.stop()
	
	get_node('%Tab').get_node("Roster/Gallery").refresh_rosters_availability()


func tab_change(idx: int):
	var dur = 0.1
	var t = get_tree().create_tween()
	t.tween_property($Tab, 'modulate', Color.transparent, dur)
	get_node('%Tab').current_tab = idx
	t.tween_property($Tab, 'modulate', Color.white, dur).set_delay(dur)
	


func _on_Play_pressed():
	var t = get_tree().create_tween()
	t.tween_property(self, 'modulate', Color.black, 1.0)
	yield(t, 'finished')
	get_tree().change_scene("res://scenes/Main.tscn")
	$"/root/Sfx".get_node('Click1').play()


func _on_Sound_toggled(button_pressed):
	AudioServer.set_bus_mute(0, button_pressed)
	
	$"/root/Sfx".get_node('Click1').play()


func _on_Shop_pressed():
	$ShopPanel.show()
	
	$"/root/Sfx".get_node('Click1').play()


func _on_Roster_pressed():
	$RosterPanel.show()
	$"/root/Sfx".get_node('Click1').play()


func _on_CloseShop_pressed():
	$ShopPanel.hide()
	$"/root/Sfx".get_node('Click1').play()


func _on_CloseRoster_pressed():
	$RosterPanel.hide()
	$"/root/Sfx".get_node('Click1').play()





func _on_Home_pressed():
	return
	get_node('%Tab').hide()


func _on_Sounds_toggled(button_pressed):
	AudioServer.set_bus_mute(0, button_pressed)
	
	$"/root/Sfx".get_node('Click1').play()
