extends Node

class_name  NoteLoader

# var packed_note : PackedScene = preload("res://Scenes/Widgets/note.tscn")

func load_note(scene : PlayScene, type : String, time : float, column : int, duration : float):
	scene.current_load_num += 1
	var instanced_note : Note = scene.packed_note.instantiate()
	
	scene.get_node("track/track" + str(column)).add_child(instanced_note)
	
	instanced_note.id = scene.current_load_num
	instanced_note.position.x = 2 * column - 5
	instanced_note.position.z = RunningData.speed * RunningData.delay_time #- RunningData.speed * time / 1000
	# if scene.total_note_num == scene.current_load_num:
		# scene.is_loading_note = false
		# RunningData.is_running_note = true
