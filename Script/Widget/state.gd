extends MarginContainer

@onready var label : Label = $Label

@onready var animation_player = $Label/AnimationPlayer

@export var state_name : String = "tap"

func _ready():
	label.text = state_name

func _process(delta):
	if GlobalScene.current_state != state_name:
		label.modulate = Color(1, 1, 1, 1)
	else:
		label.modulate = Color("66ccff")


@warning_ignore("unused_parameter")
func _on_gui_input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		GlobalScene.current_state = state_name


func _on_mouse_entered():
	print("hover on")
	animation_player.play("hover_on")

func _on_mouse_exited():
	animation_player.play_backwards("hover_on")
