extends Control


"""

|___________|___________|___________|___________|
| 376 ~ 476 | 476 ~ 576 | 576 ~ 676 | 676 ~ 776 |

"""

@onready var note: PackedScene = load("res://scenes/Notes/note.tscn")


@export_enum("0", "1", "2", "3") var column: int = 0

var mouse_x: float = 0.0
var mouse_y: float = 0.0

# 此轨道的左右边界
var l_boundary: float = 0.0
var r_boundary: float = 0.0

var status: PackedScene = null

# var pos_x: float = 0

var is_note_placed: bool = false

var is_note_erased: bool = false


func _ready() -> void:
	l_boundary = 373 + 100 * column
	r_boundary = l_boundary + 100
	status = note


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		
		# mouse_x / y 是鼠标点击点的屏幕坐标而非世界坐标
		# 下方需要根据 canvas.position.y 的大小计算出鼠标点击点的世界坐标
		mouse_x = event.position.x
		mouse_y = event.position.y
		
		# 如果点击区域不在轨道范围内, 直接返回
		if !(l_boundary <= mouse_x && mouse_x <= r_boundary):
			return
		
		# 鼠标左键点击
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			# 如果已经放置过音符，则直接返回. 如果当前状态不为音符, 则直接返回
			if is_note_placed || RuntimeData.current_status in [ 0, 1, 2, 3 ]:
				print("轨道<", column, ">被点击, 坐标: ", event.position)
				put_note()
				is_note_placed = true  # 设置标志变量为 true
			if RuntimeData.current_status == RuntimeData.STATUS.ERASE:
				print("轨道<", column, ">被橡皮擦点击, 坐标: ", event.position)
				erase_note()
		elif event.button_index == MOUSE_BUTTON_LEFT && not event.pressed:
			is_note_placed = false  # 当鼠标左键释放时，重置标志变量
		
		# 鼠标右键点击
		if event.button_index == MOUSE_BUTTON_RIGHT && event.pressed:
			# 如果已经在橡皮模式，则直接返回
			if is_note_erased:
				return
			if l_boundary <= mouse_x and mouse_x <= r_boundary:
				print("轨道<", column, ">被橡皮擦点击, 坐标: ", event.position)
				erase_note()
				is_note_erased = true  # 设置标志变量为 true
		elif event.button_index == MOUSE_BUTTON_RIGHT && not event.pressed:
			is_note_erased = false  # 当鼠标右键释放时，重置标志变量


# 放置音符
func put_note() -> void:
	for child in self.get_children():
		if child is TextureRect:
			if child.position.y == -self.global_position.y + mouse_y - (648 / 2): # 648 为屏幕高度
				print("此处已放置音符")
				return
	
	var note: TextureRect = status.instantiate()
	note.set_type(RuntimeData.current_status)
	# 计算世界坐标, 设置音符坐标
	# 要问为什么坐标这样算? 我也不知道, 我试出来的.
	note.position.x = -self.position.x + l_boundary + 3 	# 2 为偏移量
	
	# 吸附节拍线
	var mouse_to_position_y: float = -self.global_position.y + mouse_y - (648 / 2) # 648 为屏幕高度
	# 离点击处最近的距离
	var min_distance: float = abs(RuntimeData.beatline_positions[0] - mouse_to_position_y)
	# 离点击出最近的节拍线在列表中的索引
	var min_item_index: int = 0
	for index in range(len(RuntimeData.beatline_positions)):
		var distance: float = abs(RuntimeData.beatline_positions[index] - mouse_to_position_y)
		if distance <= min_distance:
			min_distance = distance
			min_item_index = index
	print("节拍线y坐标: ", RuntimeData.beatline_positions)
	print("最近节拍线y坐标: ", RuntimeData.beatline_positions[min_item_index])
	
	note.position.y = RuntimeData.beatline_positions[min_item_index] + 16
	# note.position.y = -self.global_position.y + mouse_y - (648 / 2) # 648 为屏幕高度
	
	print("note放置, 坐标: ", note.global_position)
	self.add_child(note)


# 删除音符
func erase_note() -> void:
	 # 遍历所有子节点，查找并删除音符
	for child in self.get_children():
		if child is TextureRect:
			print("音符y坐标: ", child.position.y)
			# note的锚点在左上角, 下面的坐标计算的是note中心的坐标
			# var note_x: float = child.position.x + 50 # 50 为音符宽度的一半
			var note_y: float = child.position.y + 5  # 5  为音符高度的一半
			
			# var mouse_world_x: float = -self.position.x + l_boundary + 3 	# 3 为偏移量
			var mouse_world_y: float = -self.global_position.y + mouse_y
			# 检查音符是否在鼠标点击范围内
			if abs(note_y - mouse_world_y) <= 5:
				child.queue_free()
				print("音符被删除")
