extends Control


"""

|___________|___________|___________|___________|
| 376 ~ 476 | 476 ~ 576 | 576 ~ 676 | 676 ~ 776 |

"""

@export_enum("0", "1", "2", "3") var column: int = 0


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_x: int = event.position.x
		var mouse_y: int = event.position.y
		
		var l_boundary: int = 373 + 100 * column
		var r_boundary: int = l_boundary + 100
		
		if l_boundary <= mouse_x and mouse_x <= r_boundary:
			print("轨道<", column, ">被点击, 坐标: ", event.position)
