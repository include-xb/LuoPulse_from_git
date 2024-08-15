extends MeshInstance3D

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

func _ready():
	velosity.z = RunningData.speed # 实际上, 音符速度 和 流速 之间是一个线性方程, 此处暂时省略, 直接赋值
	position.y = 0 # y 坐标永远是0

func _process(delta):
	position += velosity * delta


func set_note(note_track : int, time : float, note_type : StringName):
	position.x = 2 * note_track - 5 # 音符放置在哪条轨道
