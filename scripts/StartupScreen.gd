extends Control



func _ready():
	Firebase.Auth.connect("login_succeeded", self, 'on_login_succeeded')
	Firebase.Auth.connect("login_failed", self, 'on_login_failed')
	Firebase.Auth.connect("signup_succeeded", self, 'on_signup_succeeded')
	Firebase.Auth.connect("signup_failed", self, 'on_signup_failed')
	
	Firebase.Auth.connect("auth_request", self, 'on_auth_request')
	Firebase.Auth.connect("token_refresh_succeeded", self, 'on_token_refresh_succeeded')
	
	
	
#	Firebase.Auth.remove_auth()
#	Firebase.Auth.load_auth()



func on_login_succeeded(auth_info):
	Firebase.Auth.save_auth(auth_info)
	
	$LoginPanel.hide()
	$LoadingIndicator.show()
	
	$Error.hide()
	
#	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('users')
#	var up_task : FirestoreTask = firestore_collection.update(auth_info['localid'], ManagerGame.data)
#	var document : FirestoreDocument = yield(up_task, "update_document")
	
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene("res://scenes/Menu.tscn")


func on_login_failed(code, mes):
	$LoginPanel.show()
	
	$Error.text = mes
	$Error.text += ' Error code: ' + str(code)
	$Error.show()


func on_signup_succeeded(auth_info):
	Firebase.Auth.save_auth(auth_info)
	
	$LoginPanel.hide()
	$LoadingIndicator.show()
	
	$Error.hide()
	
	yield(get_tree().create_timer(1.0), "timeout")
	
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('users')
	var add_task : FirestoreTask = firestore_collection.add(auth_info['localid'], ManagerGame.data)
	var document : FirestoreTask = yield(add_task, "task_finished")
	
	get_tree().change_scene("res://scenes/Menu.tscn")


func on_signup_failed(auth_info):
	$Error.text = 'Error signing up, try again'
	$Error.show()


func on_auth_request(err: int, mess):
	if err != OK:
		$LoginPanel.show()


func on_token_refresh_succeeded(auth_result):
	on_login_succeeded(auth_result)




func _on_Anon_pressed():
	Firebase.Auth.login_anonymous()
	$LoginPanel.hide()


func _on_Google_pressed():
	pass # Replace with function body.


func _on_EmailPass_pressed():
	$LoginPanel.hide()
	$SignupPanel.show()






func _on_Cancel_pressed():
	$SignupPanel.hide()
	$LoginPanel.show()


func _on_Create_pressed():
	pass # Replace with function body.


func _on_Splash_gui_input(event):
	if event is InputEventScreenTouch and !event.pressed:
		$Splash/Label.hide()
		
		var t = get_tree().create_tween()
		t.tween_property($Splash/ColorRect, 'color', Color.black, 1.0)
		yield(t, "finished")
		Firebase.Auth.check_auth_file()
		$Splash.hide()
