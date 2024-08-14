extends Node3D

class_name PlayScene


# 音乐播放器
@onready var audioPlayer = $AudioStreamPlayer3D

# 谱面文件内容
var mscFile : String


func _ready():
	mscFile = RunningData.mscFile


func _process(delta):
	pass
