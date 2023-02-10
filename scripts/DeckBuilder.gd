extends Panel


var current_selected_card = null


func _ready():
	$SelectPanel.rect_pivot_offset = $SelectPanel.rect_size / 2
	
	load_deck()
	
	for card in $ScrollContainer/GridContainer.get_children():
		card.connect('clicked', self, 'on_clicked')


func load_deck():
	var count = 0
	for card in $ScrollContainer/GridContainer.get_children():
		card.data = ManagerGame.data['deck_chars'][count]
		card._ready()
		count += 1


func on_clicked(own):
	$SelectPanel.show()
	$SelectPanel.rect_scale = Vector2.ZERO
	var t = get_tree().create_tween()
	t.tween_property($SelectPanel, 'rect_scale', Vector2.ONE, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	current_selected_card = own


func _on_CloseSelect_pressed():
	var t = get_tree().create_tween()
	t.tween_property($SelectPanel, 'rect_scale', Vector2.ZERO, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
#	yield(t, "finished")
	$SelectPanel.hide()
	current_selected_card = null
