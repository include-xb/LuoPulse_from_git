extends MarginContainer


@onready var track : MarginContainer = $"."

@onready var line : VBoxContainer = $"../.."

@onready var editor_body : VBoxContainer = $"../../.."

@export var column : int = 1

var instance : TextureRect

var is_put : bool = false

var is_saved : bool = false

func _process(delta):
	if GlobalScene.start_saving_chart && is_put == true && is_saved == false:
		GlobalScene.editing_chart.HitObjects.push_back({ 
				"type": GlobalScene.current_state,
				"time": line.beat + line.division / editor_body.min_division,
				"column": column,
			})
		is_saved == true


func _on_gui_input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if GlobalScene.current_state == "eraser":
				eraser()
				return
			put()
		
		if event.button_index == MOUSE_BUTTON_RIGHT:
			eraser()


func put():
	is_put = true
	if track.get_children() == []:
		# note.visible = true
		instance = TextureRect.new()
		instance.texture = load("res://Resource/Img/NoteSingle.png")
		
		instance.stretch_mode = TextureRect.STRETCH_KEEP
		instance.size_flags_horizontal = Control.SIZE_SHRINK_CENTER # 居中收缩
		instance.size_flags_vertical = Control.SIZE_SHRINK_END		# 末端收缩
		
		track.add_child(instance)


func eraser():
	is_put = false
	if track.get_children() != []:
		instance.queue_free()
