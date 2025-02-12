extends TextureRect

var type: String = ""

var column: int = 0

var type_to_color: Array = [
	"66ccff", # tap # 0
	"ffff00", # drag # 1
	"ff0000", # release # 2
	"a00000", # heart # 3
]

func set_type(t: int) -> void:
	var type_list: Array = [ "tap", "drag", "release", "heart" ]
	if t > 4:
		print("状态错误, 当前状态非音符 (from note.gd)")
		return
	self.modulate = Color(type_to_color[t])
	type = type_list[t]
