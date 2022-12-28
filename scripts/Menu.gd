extends Control



func _ready():
	ManagerGame.connect("coins_changed", self, 'on_coins_changed')
	
	$Coins/Label.text = str(ManagerGame.player_data['coins'])
	$ShopPanel/Coins/Label.text = str(ManagerGame.player_data['coins'])


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



