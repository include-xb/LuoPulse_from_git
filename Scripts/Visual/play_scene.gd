extends Node3D

class_name PlayScene


# 音乐播放器
@onready var audioPlayer = $AudioStreamPlayer3D



func _ready():
	var xml_doc : XMLDocument = XML.parse_file(RunningData.xml_path)
	var root : XMLNode = xml_doc.root
	var dict : Dictionary = root.to_dict()
	
	# print(JSON.stringify(dict, "\t"))
	pass


func _process(delta):
	pass
