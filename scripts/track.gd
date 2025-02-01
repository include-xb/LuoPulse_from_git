extends Control


"""

|___________|___________|___________|___________|
| 376 ~ 476 | 476 ~ 576 | 576 ~ 676 | 676 ~ 776 |

"""

@onready var note: PackedScene = load("res://scenes/Notes/note.tscn")


@export_enum("0", "1", "2", "3") var column: int = 0

var mouse_x: int = 0
var mouse_y: int = 0

var status: PackedScene = null

var pos_x: int = 0

var is_note_placed: bool = false

var is_note_erased: bool = false


func _ready() -> void:
	status = note


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		#if RuntimeData.can_put_note == false:
			#return
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if is_note_placed:
				return  # 如果已经放置过音符，则直接返回
			is_note_placed = true  # 设置标志变量为 true
			
			if RuntimeData.current_status not in [ 0, 1, 2, 3 ]:
				return
			
			mouse_x = event.position.x # event.position.x
			mouse_y = event.position.y # event.position.y
			
			var l_boundary: int = 373 + 100 * column
			var r_boundary: int = l_boundary + 100
			
			if l_boundary <= mouse_x and mouse_x <= r_boundary:
				print("轨道<", column, ">被点击, 坐标: ", event.position)
				
				var note: TextureRect = status.instantiate()
				note.set_type(RuntimeData.current_status)
				# 设置音符坐标, 你要问为什么坐标这样设置, 我也不知道, 我试出来的.
				note.position.x = -self.position.x + l_boundary + 3 	# 2 为偏移量
				note.position.y = -self.global_position.y + mouse_y - (648 / 2) # 648 为屏幕高度
				print("note放置, 坐标: ", note.position)
				self.add_child(note)
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			is_note_placed = false  # 当鼠标左键释放时，重置标志变量
