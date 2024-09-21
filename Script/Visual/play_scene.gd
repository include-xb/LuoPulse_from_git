extends Node2D


class_name PlayScene


var note_loader : NoteLoader = NoteLoader.new()

# 标题
@onready var title_label : Label = $MarginContainer/HBoxContainer/MarginContainer2/Info/HBoxContainer/Name

@onready var background : TextureRect = $TextureRect

@onready var msc_player : AudioStreamPlayer2D = $MscPlayer

@onready var video_player : VideoStreamPlayer = $VideoStreamPlayer

@onready var notes : Node2D = $Panel/Notes

@onready var decision_line : Sprite2D = $Panel/DecisionLine

@onready var setting_panel : Panel = $SettingPanel

@onready var resume_timer : Timer = $ResumeTimer

@onready var time_label : Label = $ResumeTimer/Label

@onready var finish_progress : ProgressBar = $ProgressBar

@onready var perfect_box : LineEdit = $Count/Perfect/LineEdit

@onready var good_box : LineEdit = $Count/Good/LineEdit

@onready var miss_box : LineEdit = $Count/Miss/LineEdit

@onready var combe_box : LineEdit = $Count/Combe/LineEdit

@onready var panel_animation : AnimationPlayer = $Panel/Animation


var note_type_array : Array = [ ]

var note_time_array : Array = [ ]

var note_column_array : Array = [ ]

var note_duration_array : Array = [ ]

# json 中解析到的所有音符
var notes_array : Array = [ ]

var total_note_num : float = 0

var timer : float = 0

var index : int = 0



func _ready():
	GlobalScene.clear_count()
	notes.process_mode = Node.PROCESS_MODE_PAUSABLE
	msc_player.process_mode = Node.PROCESS_MODE_PAUSABLE
	video_player.process_mode = Node.PROCESS_MODE_PAUSABLE
	get_tree().paused = false
	# timer = -GlobalScene.dea
	
	time_label.visible = false
	setting_panel.visible = false
	
	perfect_box.text = "0"
	good_box.text = "0"
	miss_box.text = "0"
	combe_box.text = "0"
	
	for i in range(1, 4 + 1):
		get_node("Panel/Panel_" + str(i)).KEY = GlobalScene.key_map[str(i)]
	
	title_label.text = GlobalScene.selected_msc_title
	background.texture = GlobalScene.selected_msc_cover
	msc_player.stream = GlobalScene.selected_stream
	video_player.stream = GlobalScene.selected_video_stream
	
	notes_array = GlobalScene.parsed_json.HitObjects
	total_note_num = notes_array.size()
	
	for note in notes_array:
		note_type_array.push_back(note.type)
		note_time_array.push_back(note.time)
		note_column_array.push_back(note.column)
		note_duration_array.push_back(note.duration if note.has("duration") else 0)
	
	panel_animation.play("slide_up")
	await panel_animation.animation_finished
	
	# await get_tree().create_timer(GlobalScene.delay_time).timeout
	
	msc_player.play()
	video_player.play()


@warning_ignore("unused_parameter")
func _process(delta):
	
	# timer += delta if get_tree().paused == false else 0
	if timer <= GlobalScene.delay_time:
		timer += delta if get_tree().paused == false else 0
	else:
		timer = msc_player.get_playback_position() \
			- AudioServer.get_time_to_next_mix() \
			+ AudioServer.get_time_since_last_mix() \
			+ GlobalScene.delay_time
	
	if !GlobalScene.is_loading_note:
		return
	
	for i in range(4):
		if timer >= note_time_array[index] + GlobalScene.adjust:
			note_loader.load_note(
				self, 
				note_type_array[index], 
				note_time_array[index], 
				note_column_array[index], 
				note_duration_array[index],
				index
			)
			# print("偏正时间: ", -AudioServer.get_time_to_next_mix() + AudioServer.get_time_since_last_mix())
			index += 1
			if index >= total_note_num:
				GlobalScene.is_loading_note = false
				break
	
	if time_label.visible == true:
		time_label.text = str(int(resume_timer.time_left) + 1)
		if resume_timer.time_left <= 0:
			time_label.visible = false
	
	perfect_box.text = str(GlobalScene.perfect_count)
	good_box.text = str(GlobalScene.good_count)
	miss_box.text = str(GlobalScene.miss_count)
	combe_box.text = str(GlobalScene.combe)
	
	if GlobalScene.combe > GlobalScene.max_combe:
		GlobalScene.max_combe = GlobalScene.combe
	
	var clicked_note_num : float = GlobalScene.perfect_count + GlobalScene.good_count + GlobalScene.miss_count
	# var score : float = 100 * GlobalScene.perfect_count + 50 * GlobalScene.good_count
	if clicked_note_num != 0:
		# var score_percent : float = score / clicked_note_num
		var finish_percent : float = clicked_note_num / total_note_num
		finish_progress.value = finish_percent * 100
		# print("目前音符: ", clicked_note_num, "/", total_note_num)
		# print("完成度: ", clicked_note_num / total_note_num * 100 , "%")

@warning_ignore("unused_parameter")
func _input(event):
	if Input.is_action_pressed("Pause") and setting_panel.visible == false:
		_on_setting_button_pressed()
	if Input.is_action_pressed("Resume") and setting_panel.visible == true:
		_on_sublime_button_pressed()
	
	if Input.is_key_pressed(KEY_Q):
		_on_msc_player_finished()


# 左上角按钮
func _on_setting_button_pressed():
	if notes.process_mode == Node.PROCESS_MODE_DISABLED:
		return
	notes.process_mode = Node.PROCESS_MODE_DISABLED
	msc_player.process_mode = Node.PROCESS_MODE_DISABLED
	video_player.process_mode = Node.PROCESS_MODE_DISABLED
	setting_panel.visible = true


# 暂停面板里的继续按钮
func _on_sublime_button_pressed():
	GlobalScene.save_cfg_data()
	setting_panel.visible = false
	time_label.visible = true
	resume_timer.start(3)
	await resume_timer.timeout
	notes.process_mode = Node.PROCESS_MODE_PAUSABLE
	msc_player.process_mode = Node.PROCESS_MODE_PAUSABLE
	video_player.process_mode = Node.PROCESS_MODE_PAUSABLE


# 结束
func _on_back_pressed():
	# notes.process_mode = Node.PROCESS_MODE_DISABLED
	msc_player.stop()
	video_player.stop()
	SceneChanger.change_scene("res://Scene/VisualScene/finish_scene.tscn")


func _on_msc_player_finished():
	_on_back_pressed()
	panel_animation.play_backwards("slide_up")
	print("结束")
