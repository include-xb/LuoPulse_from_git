extends Node3D

class_name PlayScene


# 音乐播放器
@onready var audioPlayer = $AudioStreamPlayer3D

@onready var cover : Sprite3D = $Sprite3D

var note_loader = NoteLoader.new()

const ray_length : int = 1000

var touch_position_2d : Vector2 = Vector2.ZERO

# 测试用 ######
var json_contant = """{ "General": { "Title": "test", "Artist": "xxx", "Creator": "yyy", "Version": "1.0", "BPM": 120, "AudioFile": "../../.." }, "TimingPoints": [{ "time": 0, "bpm": 120 }, { "time": 5000, "bpm": 60 }], "HitObjects": [{ "type": "tap", "time": 1000, "column": 1 }, { "type": "tap", "time": 1500, "column": 2 }, { "type": "tap", "time": 2000, "column": 3 }, { "type": "tap", "time": 2500, "column": 4 }, { "type": "hold", "time": 3000, "column": 1, "duration": 1000 }, { "type": "hold", "time": 4000, "column": 4, "duration": 1000 }] }"""

var json_data : Dictionary = { }
##############

func _ready():
	json_data = JSON.parse_string(json_contant)
	
	cover.texture = RunningData.selected_msc_cover
	if cover.texture == null:
		cover.texture = preload("res://Assets/Images/hub_bg.jpg")
	
	"""
	for i in json_data.HitObjects:
		var type = i.type
		var time = i.time
		var column = i.column
		var duration = i.duration if i.has("duration") else 0
	"""
		# note_loader.load_note(self, 10)
	# print(total_note_num)
	
	pass


func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		var camera = $Camera3D # 你的相机节点
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * ray_length
		
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		var result = space_state.intersect_ray(query)
		
		if result:
			# 处理碰撞结果，例如打印碰撞对象的名称
			print("Hit object: ", result.collider.name, "; Hit Position: ", result.position)
			# print("Hit object id: ", result.collider.id)


func _process(delta):
	pass
