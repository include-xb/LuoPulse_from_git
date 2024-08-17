extends Node3D


"""
kill() 或者 queue_free() 之前, 一定需要
RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
将对象移除判定区间

"""


class_name Note

var shared_class_name : String = "Note"

var id : int = -1

var type : StringName

var velosity : Vector3 = Vector3.ZERO

"""
var duration_time : int

var track : int
"""
"""
track | position.x
  1   |     -3
  2   |     -1
  3   |      1
  4   |      3
"""

var running_timer : float = RunningData.delay_time

var add : bool = true
var remove : bool = true

func _ready():
	velosity.z = RunningData.speed # 实际上, 音符速度 和 流速 之间是一个线性方程, 此处暂时省略, 直接赋值
	position.y = 0.2 # y 坐标不变

func _process(delta):
	position += velosity * delta
	if position.z >= 5:
		RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
		queue_free()
	
	running_timer += delta
	# print(running_timer)
	if add && running_timer >= -0.6:
		add = false
		RunningData.decision_area.push_back(self)
	elif remove && running_timer >= 0.6:
		remove = false
		RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
		
		# TODO: MISSING 部分
		kill()
		print("delete: ", self)


func judge_note(touch_z : float) -> bool:
	var z = abs(position.z - touch_z)
	if z < 1:
		
		# TODO: 计分
		
		RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
		kill()
		return true
	return false


func kill():
	
	# TODO: 粒子效果...
	
	queue_free()
