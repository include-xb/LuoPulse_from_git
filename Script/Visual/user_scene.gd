extends Control


@onready var nick_name_editor : LineEdit = $VBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/LineEdit


func _ready():
	nick_name_editor.text = GlobalScene.user_name


func _on_sublime_button_pressed():
	GlobalScene.user_name = nick_name_editor.text
	SceneChanger.change_scene("res://Scene/VisualScene/hub_scene.tscn")
	print("进入 hub_scene")
