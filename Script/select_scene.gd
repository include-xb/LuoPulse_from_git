extends Control

@onready var scroll : ScrollContainer = $MarginContainer2/ScrollContainer

@onready var scroll_body : VBoxContainer = $MarginContainer2/ScrollContainer/MscList


func _ready():
	scroll.scroll_vertical = 50
	pass


func _on_scroll_container_gui_input(event : InputEvent):
	if scroll.scroll_vertical <= 0:
		#scroll.scroll_vertical = 10
		var last_child = scroll_body.get_children()[-1]
		scroll_body.move_child(last_child, 0)
		return
	if abs(scroll.scroll_vertical - scroll_body.get_end().y) <= 40:
		#scroll.scroll_vertical = scroll_body.get_end().y - 20
		var first_child = scroll_body.get_children()[0]
		scroll_body.move_child(first_child, -1)
		return


func _input(event):
	if Input.is_key_pressed(KEY_Q):
		print(scroll.scroll_vertical , "/", scroll.get_v_scroll_bar().max_value - scroll.get_end().y)


# 返回主菜单 按钮在左上角
func _on_home_button_button_down():
	SceneChanger.change_scene("res://Scene/VisualScene/start_scene.tscn")
