extends TextureRect

var type_to_color: Array = [
	"66ccff", # tap # 0
	"ffff00", # drug # 1
	"ff0000", # release # 2
	"a00000", # heart # 3
]

func set_type(type: int) -> void:
	if type > 4:
		print("状态错误, 当前状态非音符 (from note.gd)")
		return
	self.modulate = Color(type_to_color[type])
