extends Node


signal coins_changed


const SAVE_PATH = 'user://data.json'


var player_data = {
	"coins": 0,
	"roster": []
}




func _ready():
	var file = File.new()
	if file.file_exists(SAVE_PATH):
		load_game()
	else:
		new_game()


func save_game():
	var file = File.new()
	file.open(SAVE_PATH, file.WRITE)
	file.store_string(JSON.print(player_data))
	file.close()


func load_game():
	var file = File.new()
	file.open(SAVE_PATH, file.READ)
	player_data = parse_json(file.get_as_text())
	file.close()


func new_game():
	var file = File.new()
	file.open(SAVE_PATH, file.WRITE)
	file.store_string(JSON.print(player_data))
	file.close()


func int_to_currency(amount: int) -> String:
	return ''


func _notification(what):
	if what == NOTIFICATION_WM_FOCUS_OUT or what == NOTIFICATION_WM_QUIT_REQUEST:
		save_game()
