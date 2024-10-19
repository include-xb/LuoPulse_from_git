extends Control

class_name GameScene

# 音乐播放器
@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer

# 封面
@onready var cover : TextureRect = $Background/TextureRect

@onready var palse_panel : Panel = $Palse
@onready var cambo_label: Label = $CamboVBC/CamboLabel
@onready var rating_label: Label = $CamboVBC/RatingLabel
@onready var cambo_vbc: VBoxContainer = $CamboVBC
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var score_label: Label = $Score/VBoxContainer/ScoreLabel


var packed_tap_note : PackedScene = preload("res://Scenes/Widgets/Game/tap.tscn")

var packed_hold_note : PackedScene = preload("res://Scenes/Widgets/Game/hold_note.tscn")

var note_loader = NoteLoader.new()

# 触摸距离
const ray_length : int = 100

# 触摸接触坐标
var touch_position_2d : Vector2 = Vector2.ZERO

# 音符总数
var total_note_num : int = -1

# 是否正在加载音符
var is_loading_note : bool = true

# 当前加载个数 / 已经加载了多少音符
var current_load_num : int = 0

# 开始后的延时
var loader_timer : float = RunningData.delay_time #-delay_time + advanced_time

var note_time_array : Array = [ ]

#  note_time_arrat 的索引
var index : int = 0

# 存储所有音符的种类
var note_type_array : Array = [ ]

# 存储所有音符的轨道
var note_column_array : Array = [ ]

# 存储所有音符的持续时间
var note_duration_array : Array = [ ]

# 多点触摸
var touch_position : Array = [ ]

# 歌曲长度
var msc_length: float

# 测试用 ######
var json_contant = \
"""
{ 
	"General": { 
		"Title": "test", 
		"Artist": "xxx", 
		"Creator": "yyy", 
		"Version": "1.0", 
		"BPM": 120, 
		"AudioFile": "../../.." 
	}, 
	"TimingPoints": [
		{ 
			"time": 0, 
			"bpm": 120 
		}, 
		{ 
			"time": 0.5, 
			"bpm": 60 
		}
	], 
	"HitObjects": [
		{ 
			"type": "tap", 
			"time": 1, 
			"column": 1 
		}, 
		{ 
			"type": "tap", 
			"time": 1.5, 
			"column": 2 
		}, 
		{ 
			"type": "tap", 
			"time": 2, 
			"column": 3 
		}, 
		{ 
			"type": "tap", 
			"time": 2.5, 
			"column": 4 
		}, 
		{ 
			"type": "hold", 
			"time": 3, 
			"column": 1, 
			"duration": 1 
		}, 
		{ 
			"type": "hold", 
			"time": 4, 
			"column": 4, 
			"duration": 1 
		}
	] 
}
"""

var json_data : Dictionary = \
{ 
	"General": { 
		"Title": String(), 
		"Artist": String(), 
		"Creator": String(), 
		"Version": int(), 
		"BPM": int(), 
		"AudioFile": String()
	}, 
	"TimingPoints": [
		{
			"time": int(),
			"bpm": int()
		},
	],
	"HitObjects": [
		{
			"type": String(),
			"time": int(),
			"column": int(),
			"duration": int()
		},
	]
}

var temp : bool = true

func _ready() -> void:
	print("loader_timer: ", loader_timer)
	print("runningdata.delay_time:", RunningData.delay_time)

	var path: String = RunningData.selected_msc["path"]

	$Info/HBoxContainer/VBoxContainer/MscName.text = RunningData.selected_msc["name"]
	
	cover.texture = load(path + "/cover.png")
	
	$Info/HBoxContainer/VBoxContainer/ArName.text = Utils.get_short_artists_list(path)

	# 三个统计标签都初始为0
	Utils.count_clean()
	
	# 解析谱面
	json_data = JSON.parse_string(
		FileAccess.get_file_as_string(path + "/chart.json")
	)
	if json_data == null: # INFO: 谱面为空则使用 json_contant, 这只是方便运行调试
		json_data = JSON.parse_string(json_contant)
		
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
	
	$Timer.start(RunningData.delay_time)
	

func _process(delta) -> void:

	RunningData.current_audio_time = audio_player.get_playback_position() - AudioServer.get_time_to_next_mix() + AudioServer.get_time_since_last_mix()
	loader_timer += delta
	
	cambo_label.text = str(RunningData.cambo)
	rating_label.text = RunningData.rating
	score_label.text = str(int(RunningData.score))
	
	progress_bar.value = audio_player.get_playback_position()
	
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
	if !RunningData.is_auto_play:
		for note in RunningData.decision_area:
			if note.column == track:
				if abs(note.appear_time - loader_timer) < 0.05: # 正负 50ms 判定为 perfect
					# TODO: perfect
					RunningData.perfect_count += 1
					RunningData.cambo += 1
					RunningData.rating = "perfect"
					RunningData.score += RunningData.single_note_score
				else:
					# TODO: good
					RunningData.good_count += 1
					RunningData.cambo += 1
					RunningData.rating = "good"
					RunningData.score += RunningData.single_note_score * 0.7



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
