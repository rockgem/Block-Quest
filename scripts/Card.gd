extends Panel

export(String) var char_id: String 
export(Dictionary) var data = {}





func _ready():
	if char_id != '':
		get_node('%Icon').texture = load("res://assets/rosters/%s.png" % char_id)
		
		data = ManagerGame.rosters_data[char_id]
	else:
		get_node('%Name').hide()
		get_node('%Icon').hide()
	
	if data.empty() == false:
		load_data()
	else:
		$Halo.hide()
		modulate = Color(1,1,1, 0.8)


func load_data():
	get_node('%Name').text = data['name']
	get_node('%Icon').texture = load("res://assets/rosters/%s.png" % data['id'])
	
	if data.has('level'):
		pass
