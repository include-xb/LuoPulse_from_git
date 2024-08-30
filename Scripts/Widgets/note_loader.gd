extends Node

class_name NoteLoader

# var packed_note : PackedScene = preload("res://Scenes/Widgets/note.tscn")

func load_note(scene : GameScene, type : String, time : float, column : int, duration : float):
	scene.current_load_num += 1
	
	if type == "tap" || true:
		var instanced_tap : Note = scene.packed_note.instantiate()
	
		scene.get_node("track/track" + str(column)).add_child(instanced_tap)
		instanced_tap.position.x = 2 * column - 5
		instanced_tap.position.z = RunningData.speed * RunningData.delay_time #- RunningData.speed * time / 1000
	
		instanced_tap.id = scene.current_load_num
		instanced_tap.appear_time = time
	return
	if type == "hold":
		var instanced_hold : HoldNote = scene.packed_hold_note.instantiate()
	
		scene.get_node("track/track" + str(column)).add_child(instanced_hold)
		instanced_hold.position.x = 2 * column - 5
		instanced_hold.position.z = RunningData.speed * (RunningData.delay_time + duration / 2)#- RunningData.speed * time / 1000
	
		instanced_hold.id = scene.current_load_num
		instanced_hold.appear_time = time
		instanced_hold.duration = duration
		instanced_hold.mesh.size.z = RunningData.speed * duration
		instanced_hold.position.z -= RunningData.speed * duration
