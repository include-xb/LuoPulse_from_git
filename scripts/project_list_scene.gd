extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var window: Window = get_window()
	window.size = Vector2i(800, 1080)
	window.borderless = false
	window.move_to_center()
	
	$MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Label2.text = Constants.VERSION_NAME
	


func _on_create_button_pressed() -> void:
	$Window.popup_centered()


func _on_window_close_requested() -> void:
	$Window.hide()
