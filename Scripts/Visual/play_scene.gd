extends Node3D

class_name PlayScene


# 音乐播放器
@onready var audioPlayer = $AudioStreamPlayer3D

const ray_length : int = 1000

var touch_position_2d : Vector2 = Vector2.ZERO

func _ready():
	# var xml_doc : XMLDocument = XML.parse_file(RunningData.xml_path)
	# var root : XMLNode = xml_doc.root
	# var dict : Dictionary = root.to_dict()
	# print(JSON.stringify(dict, "\t"))
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
			print("Hit object id: ", result.collider.id)


func _process(delta):
	pass
