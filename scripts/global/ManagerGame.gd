extends Node


signal coins_changed
signal gems_changed
signal line_deleted

signal block_drag
signal block_release

signal chest_buy


const SAVE_PATH = 'user://data.json'


var data = {
		'name': '',
		'gold': 100,
		'gem': 10,
		'level': 1,
		'exp': 0,
		'exp_max': 100,
		'rosters': [], # array of dictionaries
		'deck_chars': [{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}]
	}

var rosters_data: Dictionary = {}

onready var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('users')


var tiers = {
	0: 'Common',
	1: 'Rare',
	2: 'Mythic',
}

var speech = [
	'Nice! great job.',
	'Keep it going!',
	'Keep them poppin',
	'Great!',
	'Awesome'
]


var roster_data_base = {
	'name': 'Mika',
	'id': 'char_mika',
	'rarity': 0,
	'level': 0,
	'exp': 0
}

var is_dragging_block = false


func _ready():
	var f = File.new()
	f.open("res://reso/data/rosters.json", f.READ)
	rosters_data = parse_json(f.get_as_text())
	f.close()


func save_game():
	pass
#	var file = File.new()
#	file.open(SAVE_PATH, file.WRITE)
#	file.store_string(JSON.print(player_data))
#	file.close()


#func load_game():
#	var file = File.new()
#	file.open(SAVE_PATH, file.READ)
#	var nd = parse_json(file.get_as_text())
#	player_data.merge(nd)
#	file.close()


#func new_game():
#	var file = File.new()
#	file.open(SAVE_PATH, file.WRITE)
#	file.store_string(JSON.print(player_data))
#	file.close()


func int_to_currency(amount: int) -> String:
	return ''


func secs_to_mins(time: int) -> String:
	var t = ''
	var m = str(time / 60)
	var s = str(time % 60)
	
	if s.length() <= 1:
		s = s.insert(0, '0')
	if m.length() <= 1:
		m = m.insert(0, '0')
	
	t = m + ':' + s
	
	return t


func _notification(what):
	if what == NOTIFICATION_WM_FOCUS_OUT or what == NOTIFICATION_WM_QUIT_REQUEST:
		save_game()
