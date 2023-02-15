tool
extends Panel

signal clicked(own)

export(String) var char_id: String 
export(Dictionary) var data = {}





func _ready():
	if char_id != '':
		get_node('%Icon').texture = load("res://assets/rosters/%s.png" % char_id)
		
		data = ManagerGame.rosters_data[char_id]
		data['level'] = 1
		data['exp'] = 0
	else:
		get_node('%Name').hide()
		get_node('%Icon').hide()
	
	if data.empty() == false:
		load_data()
	else:
		$Level.hide()
		$EXP.hide()
		$Add.show()
		$Halo.hide()
		$Icon.hide()
		modulate = Color(1,1,1, 0.8)


func load_data():
	get_node('%Name').text = data['name']
	get_node('%Level').text = 'Lvl' + str(data['level'])
	get_node('%EXP').value = float(data['exp'])
	get_node('%Icon').texture = load("res://assets/rosters/%s.png" % data['id'])
	
	$Halo.show()
	$Add.hide()
	get_node('%Icon').show()
	get_node('%Name').show()
	get_node('%Level').show()
	get_node('%EXP').show()
	
	if data.has('level'):
		pass


# status = true means char is locked stus = false means char is unlocked
func set_status(is_locked: bool = true):
	if is_locked:
		$Icon.modulate = Color.black
		$Name.text = '?????'
	else:
		$Icon.modulate = Color.white
		$Name.text = data['name']


func _on_Card_gui_input(event):
	if event is InputEventScreenTouch and !event.pressed:
		if get_global_rect().has_point(get_global_mouse_position()):
			emit_signal("clicked", self)
