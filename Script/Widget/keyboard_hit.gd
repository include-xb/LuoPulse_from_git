extends Panel

@export_enum("1", "2", "3", "4") var column : String
# @export_enum("A", "S", "D", "F", "J", "K", "L", ";") var KEY : String
var KEY : String

# var is_holding : bool = false

var current_holding : Hold = null


func _ready():
	GlobalScene.key_scene = self
	
	KEY = GlobalScene.key_map[column]
	print(column, ": ", KEY)


func _input(event : InputEvent):
	KEY = GlobalScene.key_map[column]
	if GlobalScene.auto_play:
		return
	
	if Input.is_action_pressed("PS_" + KEY):
		var column : int = int(GlobalScene.key_map.find_key(KEY))
		for note in GlobalScene.decision_area:
			if note.column == column and note.type == "hold":
				current_holding = note
				note.is_holding = true
	
	if Input.is_action_just_released("PS_" + KEY):
		if current_holding != null:
			GlobalScene.decision_area.remove_at(GlobalScene.decision_area.find(self, 0))
			current_holding.is_holding = false
			current_holding = null
			
	
	if Input.is_action_just_pressed("PS_" + KEY):
		self.modulate = Color(1, 1, 1, 0.5)
		
		var column : int = int(GlobalScene.key_map.find_key(KEY))
		for note in GlobalScene.decision_area:
			if note.column == column && note.type == "tap":
				note.judge($"../..".timer)
	else:
		self.modulate = Color(1, 1, 1, 1)
