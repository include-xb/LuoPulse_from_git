extends MeshInstance3D



"""
queue_free() 之前, 一定需要
RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
将对象移除判定区间

"""


class_name Note

# 已弃用 shared_class_name 判定音符独特标志
var shared_class_name : String = "Note"

# 每个音符特有标志, (后续可能会用到)
var id : int = -1

# 音符种类: tap / hold, 这个变量在 note_loader 中被初始化
var type : StringName

var velosity : Vector3 = Vector3.ZERO

# 音符到达判定线的时间, 这个变量在 note_loader 中被初始化
var appear_time : float = 0

# 音符从被放置就开始计时
var running_timer : float = RunningData.delay_time

var add : bool = true
var remove : bool = true

# 引用 game_scene_scene 场景, 这个引用在 note_loader 中被初始化
#var placed_scene : GameScene


func _ready():
	velosity.z = RunningData.speed # 实际上, 音符速度 和 流速 之间是一个线性方程, 此处暂时省略, 直接赋值
	position.y = 0.4 # y 坐标不变

var temp = true

func _process(delta):
	position += velosity * delta
	
	running_timer += delta
	
	# INFO: 音符判定区间: 负0.2秒 - 正0.08秒
	if add && running_timer >= -0.2:
		add = false
		RunningData.decision_area.push_back(self)
		position.y = 0.2
		#print(RunningData.decision_area.size())
	elif remove && running_timer >= 0.2:
		remove = false
		position.y = 0.4
		RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
		
		# TODO: MISSING 部分
		RunningData.missing_count += 1
		queue_free()
		#print(RunningData.decision_area.size())
	
	if RunningData.is_auto_play:
		auto_play()


func judge_note(touch_position : Vector3) -> bool:
	var z = abs(position.z - touch_position.z)
	var x = abs(position.x - touch_position.x)
	
	if z <= 1 and x <= 1.25:
		
		# TODO: 计分
		
		kill()
		return true
	return false


func auto_play():
	if position.z >= 0 and temp:
		velosity = Vector3.ZERO
		RunningData.perfect_count += 1
		kill()
		temp = false


func kill():
	RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
	# TODO: 点击效果...
	# $MeshInstance3D.mesh.material.albedo_color = Color(102, 204, 255)
	GlobalScene.play_hit_audio()
	
	queue_free()



