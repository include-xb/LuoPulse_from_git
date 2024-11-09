extends Control

class_name GameScene

# 音乐播放器
@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer

# 加载页节点
@onready var loading_panel: Control = $Loading

@onready var palse_panel : Panel = $Palse
@onready var cambo_label: Label = $CamboVBC/CamboLabel
@onready var rating_label: Label = $CamboVBC/RatingLabel
@onready var cambo_vbc: VBoxContainer = $CamboVBC
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var score_label: Label = $Score/VBoxContainer/ScoreLabel


var packed_tap_note : PackedScene = preload("res://Scenes/Widgets/Game/tap.tscn")

var packed_hold_note : PackedScene = preload("res://Scenes/Widgets/Game/hold_note.tscn")

var note_loader = NoteLoader.new()

# 音符总数
var total_note_num : int = -1

# 是否正在加载音符
var is_loading_note : bool = true

# 开始后的延时
var loader_timer : float = RunningData.delay_time #-delay_time + advanced_time

var note_time_array : Array = [ ]

var current_load_num: int = 0

#  note_time_arrat 的索引
var index : int = 0

# 存储所有音符的种类
var note_type_array : Array = [ ]

# 存储所有音符的轨道
var note_column_array : Array = [ ]

# 存储所有音符的持续时间
var note_duration_array : Array = [ ]

# 歌曲长度
var msc_length: float

var json_data : Dictionary

var temp : bool = true

func _ready() -> void:

	var path: String = RunningData.selected_msc["path"]
	var msc_name: String = RunningData.selected_msc["name"]
	var cover_img: Texture2D = load(path + "/cover.png")
	
	$Loading/Info/VBoxContainer/ChartNameLabel.text = msc_name
	$Loading/Background.texture = cover_img
	$Loading/Info/VBoxContainer/StaffListLabel.text = Utils.get_staff_list(path) + "\n" + "谱面：" + Utils.get_chart_maker(path)
		
	$Info/HBoxContainer/VBoxContainer/MscName.text = msc_name
	$Background/TextureRect.texture = cover_img

	$Info/HBoxContainer/VBoxContainer/ArName.text = Utils.get_short_artists_list(path)

	Utils.count_clean()
	
	# 解析谱面
	json_data = JSON.parse_string(
		FileAccess.get_file_as_string(path + "/chart.json")
	)

	var audio_stream: AudioStream = load(path + "/audio.mp3")
	
	progress_bar.max_value = audio_stream.get_length()

	audio_player.stream = audio_stream
	audio_player.stop()
	
	total_note_num = json_data.HitObjects.size()
	print("共有音符: ", total_note_num, "个")
	
	# 计算单个音符得分
	RunningData.single_note_score = 1000000.0 / total_note_num
	
	# 音符的各个信息写入列表
	for i in json_data.HitObjects:
		note_type_array.push_back(i.type)
		note_time_array.push_back(i.time)
		note_column_array.push_back(i.column)
		note_duration_array.push_back(i.duration if i.has("duration") else 0)
		
	# 2s伪加载
	await get_tree().create_timer(2.0).timeout
	loading_panel.queue_free()
	
	await get_tree().create_timer(2.0).timeout
	$Timer.start(RunningData.delay_time)
	

func _process(delta) -> void:

	RunningData.current_audio_time = audio_player.get_playback_position() - AudioServer.get_time_to_next_mix() + AudioServer.get_time_since_last_mix()
	loader_timer += delta
	
	cambo_label.text = str(RunningData.combo)
	rating_label.text = RunningData.rating
	score_label.text = str(int(RunningData.score))
	
	progress_bar.value = audio_player.get_playback_position()
	
	RunningData.world_timer = loader_timer
	
	if !is_loading_note:
		return
	
	# print(loader_timer)
	if loader_timer >= 0 and temp:
		audio_player.play()
		temp = false
	
	for i in range(4):
		if loader_timer >= note_time_array[index] + RunningData.delay_time:
			note_loader.load_note(
				self, 
				note_type_array[index], 
				note_time_array[index], 
				note_column_array[index], 
				note_duration_array[index]
			)
			index += 1
			
			if index >= total_note_num:
				is_loading_note = false
				return

# 暂停按钮
func _on_pause_button_pressed():
	palse_panel.visible = true
	cambo_vbc.visible = false
	get_tree().paused = true


func _on_home_button_pressed() -> void:
	print("back to home")
	palse_panel.visible = false
	audio_player.stop()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Visual/Select/mselect_scene.tscn")


func _on_resume_button_pressed() -> void:
	print("resume")
	palse_panel.visible = false
	cambo_vbc.visible = true
	get_tree().paused = false


# 判定
func _judge(track: int):
	print(RunningData.decision_area)
	if !RunningData.is_auto_play:
		for note in RunningData.decision_area:
			if note.column == track:
				if note.type == "tap":
					note.judge()



func _on_track_1_btn_pressed() -> void:
	_judge(1)
	print("t1 pressed")
	

func _on_track_2_btn_pressed() -> void:
	_judge(2)
	print("t2 pressed")


func _on_track_3_btn_pressed() -> void:
	_judge(3)
	print("t3 pressed")


func _on_track_4_btn_pressed() -> void:
	_judge(4)
	print("t4 pressed")
