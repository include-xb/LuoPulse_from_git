extends MarginContainer

class_name DemoMsc

@onready var title_label : Label = $MarginContainer/Label

@onready var animation_player : AnimationPlayer = $MarginContainer/Label/Animation

@onready var select_scene = $"../../../.."

# var is_selected : bool = false

func _ready():
	pass


@warning_ignore("unused_parameter")
func _process(delta):
	if GlobalScene.selected_demo_msc != self:
		self.modulate = Color(1, 1, 1, 1)


func set_demo_msc(msc_title : String, app = false):
	if !app:
		GlobalScene.selected_packed_name = msc_title
	title_label.text = msc_title


@warning_ignore("unused_parameter")
func _on_gui_input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		GlobalScene.selected_demo_msc = self
		select_scene.set_demo_msc_cover(title_label.text)


func _on_mouse_entered():
	animation_player.play("hover_on")

func _on_mouse_exited():
	animation_player.play_backwards("hover_on")
