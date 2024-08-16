extends Node

class_name  NoteLoader

# var packed_note : PackedScene = preload("res://Scenes/Widgets/note.tscn")

func load_note(scene : PlayScene, type : String, time : int, column : int, duration : int):
	scene.current_load_num += 1
	# if type == "hold":
	#	return
	# var note : Note = Note.new()
	
	# note.set_note(type, time, column)
	# var track : Node3D = tracks[column - 1]
	# track.add_child(note)
	var instanced_note : Note = scene.packed_note.instantiate()
	scene.add_child(instanced_note)
	
	instanced_note.id = scene.current_load_num
	instanced_note.position.x = 2 * column - 5
	instanced_note.position.z = - RunningData.speed * time / 1000
	
	if scene.total_note_num == scene.current_load_num:
		scene.is_loading_note = false
		RunningData.is_running_note = true
	
	pass
