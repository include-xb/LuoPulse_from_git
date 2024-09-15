extends Control


func _input(event):
	if Input.is_action_just_pressed("Pause"):
		_on_button_pressed()


func _on_button_pressed():
	GlobalScene.save_cfg_data()
	SceneChanger.change_scene("res://Scene/VisualScene/start_scene.tscn")
	print("进入 hub_scene")
