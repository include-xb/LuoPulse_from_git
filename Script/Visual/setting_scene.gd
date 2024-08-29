extends Control


func _on_button_pressed():
	GlobalScene.save_cfg_data()
	SceneChanger.change_scene("res://Scene/VisualScene/hub_scene.tscn")
	print("进入 hub_scene")
