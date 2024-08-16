extends ColorRect

@onready var art_name : Label = $CenterContainer/TextureRect/MarginContainer/VBoxContainer/ArName

func _ready():
	visible = false


func _on_visibility_changed():
	if visible == true:
		art_name.text = RunningData.parsed_json.General.Artist
		pass
