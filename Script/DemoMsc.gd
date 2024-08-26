extends MarginContainer


# @onready var cover : TextureRect = $TextureRect

@onready var title_label : Label = $MarginContainer/Label

@onready var animation_player : AnimationPlayer = $MarginContainer/Label/HoverAnimation


func _ready():
	pass


func set_demo_msc(msc_title : String):
	title_label.text = msc_title
	pass

"""
func _on_mouse_entered():
	animation_player.play("on_hover")


func _on_mouse_exited():
	animation_player.play_backwards("on_hover")


func _on_gui_input(event : InputEvent):
	return
	if event is InputEventMouseButton and event.is_pressed():
		if FileAccess.file_exists(GlobalScene.root_msc_path + title_label.text + "/cover.png"):
			$"../../../../TextureRect".texture = load(GlobalScene.root_msc_path + title_label.text + "/cover.png")
		else:
			$"../../../../TextureRect".texture = load("res://Resource/Img/hub_bg.jpg")
		$"../../../../MarginContainer/HBoxContainer/MarginContainer2/Info/HBoxContainer/Name".text = title_label.text
"""
