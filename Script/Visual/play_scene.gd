extends Node2D


class_name PlayScene


var note_loader : NoteLoader = NoteLoader.new()

# 标题
@onready var title_label : Label = $MarginContainer/HBoxContainer/MarginContainer2/Info/HBoxContainer/Name

@onready var background : TextureRect = $TextureRect

@onready var msc_player : AudioStreamPlayer2D = $MscPlayer

@onready var notes : Node2D = $Notes

@onready var pause_panel : Panel = $PausePanel

@onready var setting_panel : Panel = $SettingPanel

var note_type_array : Array = [ ]

var note_time_array : Array = [ ]

var note_column_array : Array = [ ]

var note_duration_array : Array = [ ]

# json 中解析到的所有音符
var notes_array : Array = [ ]

var total_note_num : int = 0

var timer : float = 0

var index : int = 0

var key_1 : String = "D"
var key_2 : String = "F"
var key_3 : String = "J"
var key_4 : String = "K"


func _ready():
	pause_panel.visible = false
	setting_panel.visible = false
	
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
	timer = msc_player.get_playback_position() \
		- AudioServer.get_time_to_next_mix() \
		+ AudioServer.get_time_since_last_mix() \
		+ GlobalScene.delay_time
	
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


func _input(event : InputEvent):
	return
	if event is InputEventKey:
		# INFO: 这里有一坨大的
		if Input.is_action_just_pressed("PS_" + key_1):
			for note in GlobalScene.decision_area:
				if note.column == 1:
					note.judge(timer)
					return
		if Input.is_action_just_pressed("PS_" + key_2):
			for note in GlobalScene.decision_area:
				if note.column == 2:
					note.judge(timer)
					return
		if Input.is_action_just_pressed("PS_" + key_3):
			for note in GlobalScene.decision_area:
				if note.column == 3:
					note.judge(timer)
					return
		if Input.is_action_just_pressed("PS_" + key_4):
			for note in GlobalScene.decision_area:
				if note.column == 4:
					note.judge(timer)
					return


func _on_pause_button_pressed():
	print("暂停")
	get_tree().paused = true
	pause_panel.visible = true


func _on_resume_pressed():
	pause_panel.visible = false
	get_tree().paused = false


func _on_setting_button_pressed():
	get_tree().paused = true
	setting_panel.visible = true


func _on_sublime_button_pressed():
	GlobalScene.save_cfg_data()
	setting_panel.visible = false
	get_tree().paused = false
