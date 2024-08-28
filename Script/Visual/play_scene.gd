extends Node2D


class_name PlayScene


var note_loader : NoteLoader = NoteLoader.new()

# 标题
@onready var title_label : Label = $MarginContainer/HBoxContainer/MarginContainer2/Info/HBoxContainer/Name

@onready var background : TextureRect = $TextureRect

@onready var msc_player : AudioStreamPlayer2D = $MscPlayer

@onready var notes : Node2D = $Notes

var note_type_array : Array = [ ]

var note_time_array : Array = [ ]

var note_column_array : Array = [ ]

var note_duration_array : Array = [ ]

# json 中解析到的所有音符
var notes_array : Array = [ ]

var total_note_num : int = 0

var timer : float = 0

var index : int = 0


func _ready():
	GlobalScene.exchange_scene = self
	
	title_label.text = GlobalScene.selected_msc_title
	background.texture = GlobalScene.selected_msc_cover
	msc_player.stream = GlobalScene.selected_stream
	
	notes_array = GlobalScene.parsed_json.HitObjects
	total_note_num = notes_array.size()
	
	for note in notes_array:
		note_type_array.push_back(note.type)
		note_time_array.push_back(note.time)
		note_column_array.push_back(note.column)
		note_duration_array.push_back(note.duration if note.has("duration") else 0)
	
	await get_tree().create_timer(GlobalScene.delay_time).timeout
	
	msc_player.play()


func _process(delta):
	timer += delta
	
	if !GlobalScene.is_loading_note:
		return
	
	for i in range(4):
		if timer >= note_time_array[index]:
			note_loader.load_note(
				self, 
				note_type_array[index], 
				note_time_array[index], 
				note_column_array[index], 
				note_duration_array[index]
			)
			index += 1
			if index >= total_note_num:
				GlobalScene.is_loading_note = false
				return


func _on_pause_button_pressed():
	print("暂停")
	get_tree().paused = true
	# SceneChanger.change_scene("res://Scene/VisualScene/start_scene.tscn")
