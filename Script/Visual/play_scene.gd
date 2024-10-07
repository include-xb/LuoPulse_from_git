extends Node2D


class_name PlayScene


var note_loader : NoteLoader = NoteLoader.new()

# 标题
@onready var title_label : Label = $MarginContainer/HBoxContainer/MarginContainer2/Info/HBoxContainer/Name

@onready var background : TextureRect = $TextureRect

@onready var msc_player : AudioStreamPlayer2D = $MscPlayer

@onready var video_player : VideoStreamPlayer = $VideoStreamPlayer

@onready var bglight_panel : Panel = $BGlight

@onready var notes : Node2D = $Panel/Notes

@onready var track_panel : Control = $Panel

@onready var decision_line : Sprite2D = $Panel/DecisionLine

@onready var setting_panel : Panel = $SettingPanel

@onready var resume_timer : Timer = $ResumeTimer

@onready var time_label : Label = $ResumeTimer/Label

@onready var finish_progress : ProgressBar = $ProgressBar


@onready var perfect_plus_box : LineEdit = $"Count/Perfect+/LineEdit"
@onready var perfect_box : LineEdit = $Count/Perfect/LineEdit
@onready var great_box : LineEdit = $Count/Great/LineEdit
@onready var good_box : LineEdit = $Count/Good/LineEdit
@onready var bad_box : LineEdit = $Count/Bad/LineEdit
@onready var miss_box : LineEdit = $Count/Miss/LineEdit
@onready var acc_box : Label = $Acc/Acc
@onready var combo_box : Label = $Combo/Combo

@onready var panel_animation : AnimationPlayer = $Panel/Animation

@onready var autoplay_label : Label = $Info/Info/Auto

@onready var user_label : Label = $Info/Info/User

@onready var label_0 : Label = $KeyTip/HBoxContainer/Label0
@onready var label_1 : Label = $KeyTip/HBoxContainer/Label1
@onready var label_2 : Label = $KeyTip/HBoxContainer/Label2
@onready var label_3 : Label = $KeyTip/HBoxContainer/Label3
@onready var label_4 : Label = $KeyTip/HBoxContainer/Label4
@onready var label_5 : Label = $KeyTip/HBoxContainer/Label5


var note_type_array : Array = [ ]

var note_time_array : Array = [ ]

var note_column_array : Array = [ ]

var note_duration_array : Array = [ ]

# json 中解析到的所有音符
var notes_array : Array = [ ]

var total_note_num : float = 0

var audio_length : float = 0

var timer : float = 0

var index : int = 0



func pause_by_mode():
	notes.process_mode = Node.PROCESS_MODE_DISABLED
	msc_player.process_mode = Node.PROCESS_MODE_DISABLED
	video_player.process_mode = Node.PROCESS_MODE_DISABLED
	track_panel.process_mode = Node.PROCESS_MODE_DISABLED
	

func resume_by_mode():
	track_panel.process_mode = Node.PROCESS_MODE_PAUSABLE
	notes.process_mode = Node.PROCESS_MODE_PAUSABLE
	msc_player.process_mode = Node.PROCESS_MODE_PAUSABLE
	video_player.process_mode = Node.PROCESS_MODE_PAUSABLE



func _ready():
	GlobalScene.clear_count()
	resume_by_mode()
	get_tree().paused = false
	# timer = -GlobalScene.dea
	GlobalScene.play_scene = self
	
	var c : float = (100 - GlobalScene.bglight) / 80
	bglight_panel.self_modulate = Color(1, 1, 1, c)
	
	autoplay_label.visible = GlobalScene.auto_play
	user_label.text = GlobalScene.user_name
	
	time_label.visible = false
	setting_panel.visible = false
	
	perfect_plus_box.text = "0"
	perfect_box.text = "0"
	great_box.text = "0"
	good_box.text = "0"
	bad_box.text = "0"
	miss_box.text = "0"
	acc_box.text = "0"
	combo_box.text = "0"
	
	# shisha, 要改
	label_0.visible = GlobalScene.display_key_tip
	label_1.visible = GlobalScene.display_key_tip
	label_2.visible = GlobalScene.display_key_tip
	label_3.visible = GlobalScene.display_key_tip
	label_4.visible = GlobalScene.display_key_tip
	label_5.visible = GlobalScene.display_key_tip
	
	label_0.text = GlobalScene.key_map["5"]
	label_1.text = GlobalScene.key_map["1"]
	label_2.text = GlobalScene.key_map["2"]
	label_3.text = GlobalScene.key_map["3"]
	label_4.text = GlobalScene.key_map["4"]
	label_5.text = GlobalScene.key_map["6"]
	
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
	
	audio_length = GlobalScene.selected_stream.get_length()
	
	print(GlobalScene.parsed_json.General)
	print(get_tree().paused)


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
	
	perfect_plus_box.text = str(GlobalScene.perfect_plus_count)
	perfect_box.text = str(GlobalScene.perfect_count)
	great_box.text = str(GlobalScene.great_count)
	good_box.text = str(GlobalScene.good_count)
	bad_box.text = str(GlobalScene.bad_count)
	miss_box.text = str(GlobalScene.miss_count)
	combo_box.text = str(GlobalScene.combo)
	
	GlobalScene.average_acc = round(GlobalScene.average_acc * 10000) / 10000
	acc_box.text = str(GlobalScene.average_acc)
	
	if GlobalScene.combo > GlobalScene.max_combo:
		GlobalScene.max_combo = GlobalScene.combo
	
	if timer >= 0:
		var finish_percent : float = timer / audio_length
		finish_progress.value = finish_percent * 100

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
	pause_by_mode()
	setting_panel.visible = true


# 暂停面板里的继续按钮
func _on_sublime_button_pressed():
	GlobalScene.save_cfg_data()
	setting_panel.visible = false
	time_label.visible = true
	resume_timer.start(3)
	await resume_timer.timeout
	
	resume_by_mode()


# 结束
func _on_back_pressed():
	# notes.process_mode = Node.PROCESS_MODE_DISABLED
	pause_by_mode()
	SceneChanger.change_scene("res://Scene/VisualScene/play_scene.tscn")


func _on_msc_player_finished():
	pause_by_mode()
	SceneChanger.change_scene("res://Scene/VisualScene/finish_scene.tscn")
	
	panel_animation.play_backwards("slide_up")
	print("结束")


func _on_quit_pressed():
	pause_by_mode()
	SceneChanger.change_scene("res://Scene/VisualScene/select_scene.tscn")
