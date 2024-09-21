extends Control


@onready var user_name_editor : LineEdit = $ScrollContainer/VBoxContainer/UserName/MarginContainer/HBoxContainer/LineEdit

@onready var tip_label : Label = $ScrollContainer/VBoxContainer/UserName/MarginContainer/HBoxContainer/TipLabel


func _ready():
	user_name_editor.text = GlobalScene.user_name


func _input(event):
	if Input.is_action_just_pressed("Pause"):
		pass


func _on_line_edit_text_changed(new_text : String):
	var length = new_text.length()
	if length > GlobalScene.max_user_name_length:
		# print("用户名过长")
		tip_label.text = "用户名过长"
		tip_label.visible = true
	elif length == 0:
		# print("用户名不能为空")
		tip_label.text = "用户名不能为空"
		tip_label.visible = true
	else:
		tip_label.visible = false
	
	if tip_label.visible:
		return
	GlobalScene.user_name = user_name_editor.text
	GlobalScene.save_cfg_data()
