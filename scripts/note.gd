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


#func _on_gui_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:# and event.pressed:
		#if event.button_index == MOUSE_BUTTON_RIGHT:
			#print("右键清除")
			#self.queue_free()
		#if RuntimeData.current_status == RuntimeData.STATUS.ERASE:
			#print("橡皮擦清除")
			#self.queue_free()
		##if event.button_index == MOUSE_BUTTON_LEFT:
			##if RuntimeData.current_status in [0, 1, 2, 3]: # tap drug release heart
				##RuntimeData.can_put_note = false
