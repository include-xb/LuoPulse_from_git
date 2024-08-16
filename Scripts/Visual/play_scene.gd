extends Node3D

class_name PlayScene


@onready var camera = $Camera3D

# 音乐播放器
@onready var audio_player = $AudioStreamPlayer3D

# 封面
@onready var cover : Sprite3D = $Sprite3D


var packed_note : PackedScene = preload("res://Scenes/Widgets/note.tscn")

var note_loader = NoteLoader.new()

# 触摸距离
const ray_length : int = 1000

# 触摸接触坐标
var touch_position_2d : Vector2 = Vector2.ZERO

# 音符总数
var total_note_num : int = -1

# 是否正在加载音符
var is_loading_note : bool = true

# 每一次加载的音符数量
var once_load_num : int = 20

# 最后一次加载音符数量
var last_load_num : int = -1

# 加载次数
var load_times : int = 0

# 当前加载次数
var current_load_times : int = 0

# 当前加载个数 / 已经加载了多少音符
var current_load_num : int = 0

# 音符提前多少毫秒加载
var advanced_time : int = 1000

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
			"time": 5000, 
			"bpm": 60 
		}
	], 
	"HitObjects": [
		{ 
			"type": "tap", 
			"time": 1000, 
			"column": 1 
		}, 
		{ 
			"type": "tap", 
			"time": 1500, 
			"column": 2 
		}, 
		{ 
			"type": "tap", 
			"time": 2000, 
			"column": 3 
		}, 
		{ 
			"type": "tap", 
			"time": 2500, 
			"column": 4 
		}, 
		{ 
			"type": "hold", 
			"time": 3000, 
			"column": 1, 
			"duration": 1000 
		}, 
		{ 
			"type": "hold", 
			"time": 4000, 
			"column": 4, 
			"duration": 1000 
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
	json_data = JSON.parse_string(json_contant)
	
	audio_player.stream = RunningData.audio_stream
	
	if cover.texture == null:
		cover.texture = preload("res://Assets/Images/hub_bg.jpg")
	else:
		cover.texture = RunningData.selected_msc_cover
	
	total_note_num = json_data.HitObjects.size()
	load_times = int(total_note_num / once_load_num)
	last_load_num = int(total_note_num % once_load_num)
	
	print("共有音符: ", total_note_num, "个")
	print("每次加载: ", once_load_num , "个")
	print("需要加载: ", load_times, "次")
	print("最后一次需要加载: ", last_load_num, "个")
	
	"""
	for i in json_data.HitObjects:
		var type = i.type
		var time = i.time
		var column = i.column
		var duration = i.duration if i.has("duration") else 0
	"""
	
	audio_player.play()


func _process(delta) -> void:
	RunningData.current_audio_time = int( 
		( 
			audio_player.get_playback_position() - AudioServer.get_time_to_next_mix() + AudioServer.get_time_since_last_mix()
		) * 1000 
	)
	# print(RunningData.current_audio_time)
	
	if is_loading_note:
		var obj = json_data.HitObjects[current_load_num]
		var type = obj.type
		var time = obj.time
		var column = obj.column
		var duration = obj.duration if obj.has("duration") else 0
		note_loader.load_note(self, type, time, column, duration)

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
			print("Hit object: ", result.collider.name)
			# print("Hit object id: ", result.collider.id)
			# if result.collider.name == "Note":
			result.collider.queue_free()
