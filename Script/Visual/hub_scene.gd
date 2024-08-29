extends Control

@onready var user_name_label : Label = $Header/HBoxContainer/UserInfo/Label

@onready var version_label : Label = $Header/HBoxContainer/GameInfo/HBoxContainer/Version


func  _ready():
	user_name_label.text = GlobalScene.user_name
	version_label.text = GlobalScene.version
	
	user_name_label.max_lines_visible = GlobalScene.max_user_name_length
	user_name_label.visible_characters = GlobalScene.max_user_name_length


func _on_texture_rect_gui_input(event : InputEvent):
	if event.is_pressed():
		SceneChanger.change_scene("res://Scene/VisualScene/user_scene.tscn")
		print("进入 user_scene")


func _on_button_pressed():
	SceneChanger.change_scene("res://Scene/VisualScene/select_scene.tscn")
	print("进入 select_scene")


func _on_setting_button_pressed():
	SceneChanger.change_scene("res://Scene/VisualScene/setting_scene.tscn")
	print("进入 setting_scene")
