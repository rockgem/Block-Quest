extends TextureButton


signal clicked(price, arr)

export(int) var price = 100

export(Array, String) var heroes_inside


func _ready():
	$Price.text = str(price)


func _on_Box_pressed():
	emit_signal("clicked", price, heroes_inside)
