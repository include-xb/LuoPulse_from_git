extends Node3D

class_name PlayScene


@onready var camera = $Camera3D

# 音乐播放器
@onready var audio_player = $AudioStreamPlayer3D

# 封面
@onready var cover : Sprite3D = $Sprite3D


@onready var track1 : Node3D = $track/track1
@onready var track2 : Node3D = $track/track2
@onready var track3 : Node3D = $track/track3
@onready var track4 : Node3D = $track/track4


var packed_note : PackedScene = preload("res://Scenes/Widgets/note.tscn")

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
var delay_time : int = 1

# 开始后的延时
var loader_timer : float = RunningData.delay_time #-delay_time + advanced_time

var note_time_array : Array = [ ]

#  note_time_arrat 的索引
var index : int = 0

var note_type_array : Array = [ ]

var note_column_array : Array = [ ]

var note_duration_array : Array = [ ]

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

func _ready() -> void:
	# json_data = JSON.parse_string(json_contant)
	json_data = RunningData.parsed_json
	if json_data == { }: json_data = JSON.parse_string(json_contant)
	
	audio_player.stream = RunningData.audio_stream
	audio_player.stop()
	
	if cover.texture == null:
		cover.texture = preload("res://Assets/Images/hub_bg.jpg")
	else:
		cover.texture = RunningData.selected_msc_cover
	
	total_note_num = json_data.HitObjects.size()
	# load_times = int(total_note_num / once_load_num)
	# last_load_num = int(total_note_num % once_load_num)
	
	print("共有音符: ", total_note_num, "个")
	# print("每次加载: ", once_load_num , "个")
	# print("需要加载: ", load_times, "次")
	# print("最后一次需要加载: ", last_load_num, "个")
	
	for i in json_data.HitObjects:
		note_type_array.push_back(i.type)
		note_time_array.push_back(i.time)
		note_column_array.push_back(i.column)
		note_duration_array.push_back(i.duration if i.has("duration") else 0)
		print(i)
	
	audio_player.play()


func _process(delta) -> void:
	RunningData.current_audio_time = audio_player.get_playback_position() - AudioServer.get_time_to_next_mix() + AudioServer.get_time_since_last_mix()
		 
	# print(RunningData.current_audio_time)
	loader_timer += delta
	
	if is_loading_note:
		if loader_timer >= note_time_array[index]:
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


func _input(event) -> void:
	if event is InputEventScreenTouch and event.pressed:
		
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * ray_length
		
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		var result : Dictionary = { "collider": Node3D }
		result = space_state.intersect_ray(query)
		
		if result:
			# 处理碰撞结果
			# print("Hit object: ", result.collider.name)
			# print("Hit object id: ", result.collider.id)
			
			for tl in $track/touch_lines.get_children():
				tl.queue_free()
			
			var instanced_touch_line = packed_touch_line.instantiate()
			instanced_touch_line.position.x = result.position.x
			instanced_touch_line.position.y = 0.01
			instanced_touch_line.position.z = -33
			$track/touch_lines.add_child(instanced_touch_line)
			
			# if not(null in RunningData.decision_area):
			for i in RunningData.decision_area:
				print(result.position.z)
				print(i)
				print(RunningData.decision_area)
				print(result)
				print(result.size())
				# if i != null && i.judge_note(result.position.z):
				if i.judge_note(result.position.z):
					print("ok")
					print("当前列表: ", RunningData.decision_area)
					
					# TODO: good 和 perfect 判定
					
					event.set_canceled(false)

