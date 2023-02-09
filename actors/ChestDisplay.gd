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
	
	ManagerGame.emit_signal("chest_buy")
	ManagerGame.emit_signal("coins_changed")
