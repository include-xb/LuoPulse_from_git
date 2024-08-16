extends StaticBody3D

class_name Note

var id : int = -1

var type : StringName

var velosity : Vector3 = Vector3.ZERO

var duration_time : int

var track : int
"""
track | position.x
  1   |     -3
  2   |     -1
  3   |      1
  4   |      3
"""

var is_set : bool = false

func _ready():
	velosity.z = RunningData.speed # 实际上, 音符速度 和 流速 之间是一个线性方程, 此处暂时省略, 直接赋值
	position.y = 0.2 # y 坐标不变

func _process(delta):
	if is_set:
		position += velosity * delta

func set_note(note_type : StringName, time : float, note_track : int):
	position.x = 2 * note_track - 5 # 音符放置在哪条轨道
	position.z = - time / (RunningData.speed * 10)
	print(position)
	is_set = true
