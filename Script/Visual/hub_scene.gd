extends Control

@onready var user_name_label : Label = $UserInfo/HBoxContainer/Label


func  _ready():
	user_name_label.text = GlobalScene.user_name


func _on_texture_rect_gui_input(event : InputEvent):
	if event.is_pressed():
		SceneChanger.change_scene("res://Scene/VisualScene/user_scene.tscn")
		print("进入 user_scene")


func _on_button_pressed():
	SceneChanger.change_scene("res://Scene/VisualScene/select_scene.tscn")
	print("进入 user_scene")
