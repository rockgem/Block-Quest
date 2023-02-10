extends Panel



func _ready():
	$PopOnBuy.rect_pivot_offset = $PopOnBuy.rect_size / 2
	
	$PopOnBuy.rect_scale = Vector2.ZERO


func pop(data: Dictionary):
	data['level'] = 1
	data['exp'] = 0
	$PopOnBuy/Card.data = data
	$PopOnBuy/Card.load_data()
	$PopOnBuy.show()
	var t = get_tree().create_tween()
	t.tween_property($PopOnBuy, 'rect_scale', Vector2.ONE, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _on_Ok_pressed():
	
#	$PopOnBuy.rect_scale = Vector2.ZERO
	var t = get_tree().create_tween()
	t.tween_property($PopOnBuy, 'rect_scale', Vector2.ZERO, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	yield(t, "finished")
	$PopOnBuy.hide()
