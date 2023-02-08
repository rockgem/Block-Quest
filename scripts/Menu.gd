extends Control



func _ready():
	ManagerGame.connect("coins_changed", self, 'on_coins_changed')
	Firebase.Auth.connect("userdata_received", self, 'on_userdata_received')
	Firebase.Auth.get_user_data()


func on_userdata_received(userdata):
	$LoggedinUserId.text = userdata.local_id
	
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('users')
	firestore_collection.get(userdata['local_id'])
	var document : FirestoreDocument = yield(firestore_collection, "get_document")
	
	ManagerGame.data = document.doc_fields
	
	get_node('%Level').text = str(ManagerGame.data['level'])
	get_node('%Gold').text = str(ManagerGame.data['gold'])
	get_node('%EXP').text = str(ManagerGame.data['exp'])
#	$Coins/Label.text = str(ManagerGame.data['gold'])
#	$ShopPanel/Coins/Label.text = str(ManagerGame.data['gold'])


func on_coins_changed():
	$Coins/Label.text = str(ManagerGame.player_data['coins'])


func _on_Play_pressed():
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
	get_node('%Tab').hide()


func _on_EditRoster_pressed():
	get_node('%Tab').show()
