extends Control

@onready var user_name_label : Label = $ColorRect/UserInfo/HBoxContainer/Label

@onready var inner_scene_changer : AnimationPlayer = $ColorRect/InnerSceneChanger


func  _ready():
	user_name_label.text = GlobalScene.user_name


func _on_texture_rect_gui_input(event : InputEvent):
	if event.is_pressed():
		inner_scene_changer.play("fade_out")
		await inner_scene_changer.animation_finished
		get_tree().change_scene_to_file("res://Scene/VisualScene/user_scene.tscn")
		inner_scene_changer.play_backwards("fade_out")
		print("进入 user_scene")
		
