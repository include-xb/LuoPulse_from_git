extends Control


@onready var user_name_editor : LineEdit = $MainBody/MarginContainer/CentralPanel/PanelBody/VBoxContainer/UserName/MarginContainer/HBoxContainer/LineEdit

@onready var tip_label : Label = $MainBody/MarginContainer/CentralPanel/PanelBody/VBoxContainer/UserName/MarginContainer/HBoxContainer/TipLabel


func _ready():
	user_name_editor.text = GlobalScene.user_name


func _input(event):
	if Input.is_action_just_pressed("Pause"):
		_on_sublime_button_pressed()


func _on_sublime_button_pressed():
	if tip_label.visible:
		return
	GlobalScene.user_name = user_name_editor.text
	GlobalScene.save_cfg_data()
	SceneChanger.change_scene("res://Scene/VisualScene/start_scene.tscn")
	print("进入 hub_scene")


func _on_line_edit_text_changed(new_text : String):
	var length = new_text.length()
	if length > GlobalScene.max_user_name_length:
		print("用户名过长")
		tip_label.text = "用户名过长"
		tip_label.visible = true
	elif length == 0:
		print("用户名不能为空")
		tip_label.text = "用户名不能为空"
		tip_label.visible = true
	else:
		tip_label.visible = false
