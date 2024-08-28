extends Node

class_name NoteLoader

var packed_tap : PackedScene = preload("res://Scene/WidgetScene/tap.tscn")

func load_note(
		scene : PlayScene, 
		type : String, 
		time : float, 
		column : int, 
		duration : float ) -> void:
	var instanced_note : Node2D
	if type == "tap":
		instanced_note = packed_tap.instantiate()
	elif type == "hold":
		instanced_note = packed_tap.instantiate()
	instanced_note.position.x = 100 * column - 250
	instanced_note.position.y = 230 - GlobalScene.speed * GlobalScene.delay_time
	
	scene.notes.add_child(instanced_note)
