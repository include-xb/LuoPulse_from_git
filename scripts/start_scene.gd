extends Control

func _ready() -> void:
	$MarginContainer/VBoxContainer/Label2.text = Constants.VERSION_NAME
	var window: Window = get_window()
	window.size = Vector2i(960, 540)
	window.borderless = true
	window.move_to_center()
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/project_list_scene.tscn")
