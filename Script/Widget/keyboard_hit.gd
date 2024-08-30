extends Panel

@export_enum("1", "2", "3", "4") var column : String
# @export_enum("A", "S", "D", "F", "J", "K", "L", ";") var KEY : String
var KEY : String

# Called when the node enters the scene tree for the first time.
func _ready():
	KEY = GlobalScene.key_map[column]
	print(column, ": ", KEY)


func _input(event : InputEvent):
	KEY = GlobalScene.key_map[column]
	if GlobalScene.auto_play:
		return
	if Input.is_action_just_pressed("PS_" + KEY):
		self.modulate = Color(1, 1, 1, 0.5)
		
		var column : int = int(GlobalScene.key_map.find_key(KEY))
		for note in GlobalScene.decision_area:
			if note.column == column:
				note.judge($"../..".timer)
	else:
		self.modulate = Color(1, 1, 1, 1)
