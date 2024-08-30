extends Node3D

class_name GameScene


@onready var camera : Camera3D = $Camera3D

# 音乐播放器
@onready var audio_player : AudioStreamPlayer3D = $AudioStreamPlayer3D

# 封面
# @onready var cover : Sprite3D = $Sprite3D

# 四条轨道
@onready var track1 : Node3D = $track/track1
@onready var track2 : Node3D = $track/track2
@onready var track3 : Node3D = $track/track3
@onready var track4 : Node3D = $track/track4

@onready var perfect_count : Label = $Control/VBoxContainer/MarginContainer/HBoxContainer/PerfectCount
@onready var good_count : Label = $Control/VBoxContainer/MarginContainer2/HBoxContainer/GoodCount
@onready var missing_count : Label = $Control/VBoxContainer/MarginContainer3/HBoxContainer/MissingCount

@onready var resume_panel : Panel = $Control/Panel

var packed_note : PackedScene = preload("res://Scenes/Widgets/note.tscn")

var packed_hold_note : PackedScene = preload("res://Scenes/Widgets/hold_note.tscn")

var packed_touch_line : PackedScene = preload("res://Scenes/Widgets/touch_line.tscn")

var note_loader = NoteLoader.new()

# 触摸距离
const ray_length : int = 100

# 触摸接触坐标
var touch_position_2d : Vector2 = Vector2.ZERO

# 音符总数
var total_note_num : int = -1

# 是否正在加载音符
var is_loading_note : bool = true

# 每一次加载的音符数量
#var once_load_num : int = 20

# 最后一次加载音符数量
#var last_load_num : int = -1

# 加载次数
#var load_times : int = 0

# 当前加载次数
#var current_load_times : int = 0

# 当前加载个数 / 已经加载了多少音符
var current_load_num : int = 0

# 音符提前多少毫秒加载
#var advanced_time : int = 1

# 开始时留给玩家的等待时间
# var delay_time : int = 1

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
##############

var temp : bool = true

func _ready() -> void:
	print("loader_timer: ", loader_timer)
	print("runningdata.delay_time:", RunningData.delay_time)

	var path: String = RunningData.selected_msc["path"]

	$Control/MarginContainer/MscNameLabel.text = RunningData.selected_msc["name"]

	# 三个统计标签都初始为0
	Utils.count_clean()
	perfect_count.text = "0"
	good_count.text = "0"
	missing_count.text = "0"
	
	# 解析谱面
	json_data = JSON.parse_string(
		FileAccess.get_file_as_string(path + "/chart.json")
	)
	if json_data == null: # INFO: 谱面为空则使用 json_contant, 这只是方便运行调试
		json_data = JSON.parse_string(json_contant)

	audio_player.stream = load(path + "/audio.mp3")
	audio_player.stop()
	
	"""
	if cover.texture == null:
		cover.texture = load("res://Assets/Images/hub_bg.jpg")
	else:
		cover.texture = path + "/cover.png"
	"""
	
	total_note_num = json_data.HitObjects.size()
	print("共有音符: ", total_note_num, "个")
	
	# 音符的各个信息写入列表
	for i in json_data.HitObjects:
		note_type_array.push_back(i.type)
		note_time_array.push_back(i.time)
		note_column_array.push_back(i.column)
		note_duration_array.push_back(i.duration if i.has("duration") else 0)
	
	$Timer.start(RunningData.delay_time)
	
	# audio_player.play()


func _process(delta) -> void:

	RunningData.current_audio_time = audio_player.get_playback_position() - AudioServer.get_time_to_next_mix() + AudioServer.get_time_since_last_mix()
	loader_timer += delta
	
	missing_count.text = str(RunningData.missing_count)
	perfect_count.text = str(RunningData.perfect_count)
	good_count.text = str(RunningData.good_count)
	
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

"""
func _input(event) -> void:
	if not(event is InputEventScreenTouch and event.pressed):
		return

	var from = camera.project_ray_origin(event.position)
	var to = from + camera.project_ray_normal(event.position) * ray_length
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result : Dictionary = { "collider": Node3D }
	result = space_state.intersect_ray(query)
	
	if result == { }:
		return
	
	for tl in $track/touch_lines.get_children():
		tl.queue_free()
	
	var instanced_touch_line = packed_touch_line.instantiate()
	instanced_touch_line.position.x = result.position.x
	instanced_touch_line.position.y = 0.01
	instanced_touch_line.position.z = -33
	$track/touch_lines.add_child(instanced_touch_line)
	
	for i in RunningData.decision_area:
		if !i.judge_note(result.position.z):
			return
		
		if abs(i.appear_time - loader_timer - RunningData.delay_time) < 0.3:
			# TODO: perfect
			perfect_hote()
		else:
			# TODO: good
			good_note()
		# event.set_canceled(false)
"""


func _input(event):
	if RunningData.is_auto_play:
		return
	
	if event.is_pressed() == false:
		for touch_line in $track/touch_lines.get_children():
			touch_line.queue_free()
	
	if not(event is InputEventScreenTouch and event.pressed):
	# if not(event is InputEventScreenTouch):
		return
	
	var touch_count = event.get_index() + 1
	print("touch_count: ", touch_count)
	print(event)
	var space_state = get_world_3d().direct_space_state

	for ind in range(touch_count):
		# 获取每个触摸点的位置
		
		# var touch_index = ind
		var touch_position = event.position
		var from = camera.project_ray_origin(touch_position)
		var to = from + camera.project_ray_normal(touch_position) * ray_length

		# 创建射线查询参数
		var query = PhysicsRayQueryParameters3D.new()
		query.from = from
		query.to = to

		# 执行射线检测
		var result = space_state.intersect_ray(query)
		
		if result == { }:
			# 如果没有检测到碰撞，在这里处理没有碰撞的情况
			return
		
		# print(result.position)
		# 处理每个触摸点的碰撞结果
		var instanced_touch_line = packed_touch_line.instantiate()
		instanced_touch_line.position.x = result.position.x
		instanced_touch_line.position.y = 0.01  # 根据需要调整高度
		instanced_touch_line.position.z = -33   # 根据需要调整深度
		$track/touch_lines.add_child(instanced_touch_line)
		
		for i in RunningData.decision_area:
			if i == null || !i.judge_note(result.position): # || 运算符具有短路性
				return
			if abs(i.appear_time - loader_timer) < 0.05: # 正负 50ms 判定为 perfect
				# TODO: perfect
				RunningData.perfect_count += 1
			else:
				# TODO: good
				RunningData.good_count += 1

# 暂停按钮
func _on_pause_button_pressed():
	resume_panel.visible = true
	get_tree().paused = true


func _on_home_button_pressed() -> void:
	print("back to home")
	resume_panel.visible = false
	audio_player.stop()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Visual/Select/mselect_scene.tscn")


func _on_resume_button_pressed() -> void:
	print("resume")
	resume_panel.visible = false
	get_tree().paused = false
