extends Panel

export(String) var char_id: String 



func _ready():
	$Icon.texture = load("res://assets/rosters/%s.png" % char_id)
