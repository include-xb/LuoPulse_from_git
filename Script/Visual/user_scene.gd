extends Control


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scene/VisualScene/hub_scene.tscn")
	print("进入 hub_scene")
