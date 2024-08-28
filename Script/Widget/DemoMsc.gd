extends MarginContainer

class_name DemoMsc

@onready var title_label : Label = $MarginContainer/Label

@onready var animation_player : AnimationPlayer = $MarginContainer/Label/ClickAnimation

@onready var select_scene = $"../../../.."


func _ready():
	pass


func set_demo_msc(msc_title : String):
	title_label.text = msc_title


func _on_gui_input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		animation_player.play("click_on")
		select_scene.set_demo_msc_cover(title_label.text)
