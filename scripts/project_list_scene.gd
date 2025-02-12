extends Control



func _ready() -> void:
	var window: Window = get_window()
	window.size = Vector2i(800, 600)
	window.borderless = false
	window.move_to_center()
	
	$MarginContainer/VBoxContainer/Title/VBoxContainer/Version.text = Constants.VERSION_NAME
	$Window.size = Vector2i(1440, 950)


func _on_create_button_pressed() -> void:
	$Window.popup_centered()


func _on_window_close_requested() -> void:
	$Window.hide()
