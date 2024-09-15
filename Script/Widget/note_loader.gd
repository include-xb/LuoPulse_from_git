extends Node

class_name NoteLoader

var packed_tap : PackedScene = preload("res://Scene/WidgetScene/tap.tscn")

var packed_hold : PackedScene = preload("res://Scene/WidgetScene/hold.tscn")

func load_note(
		scene : PlayScene, 
		type : String, 
		time : float, 
		column : int, 
		duration : float,
		index : int
	) -> void:
	
	var instanced_note : Node2D
	if type == "tap":
		instanced_note = packed_tap.instantiate()
	elif type == "hold":
		instanced_note = packed_hold.instantiate()
	
	instanced_note.scene = scene
	instanced_note.position.x = 100 * column - 250
	# instanced_note.position.y = 230 - GlobalScene.speed * GlobalScene.delay_time
	instanced_note.position.y = scene.decision_line.position.y - GlobalScene.speed * GlobalScene.delay_time
	
	instanced_note.type = type
	instanced_note.column = column
	instanced_note.duration = duration
	instanced_note.id = index
	
	scene.notes.add_child(instanced_note)
	
	if GlobalScene.first_note_time == -1:
		GlobalScene.first_note_time = time
		print(GlobalScene.first_note_time)
