extends Panel




func _ready():
	load_deck()


func load_deck():
	var count = 0
	for card in $ScrollContainer/GridContainer.get_children():
		card.data = ManagerGame.data['deck_chars'][count]
		count += 1
