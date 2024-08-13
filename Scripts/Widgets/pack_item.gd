extends VBoxContainer

var grid: GridContainer

func set_up(name: String, mscList: Array[String]) -> void:
	var label: Label = $PanelContainer/PackPic/MarginContainer/PackNameLabel
	grid = $GridContainer
	
	label.text = name
	
	for i in mscList:
		var item: Node = preload("res://Scenes/Widgets/msc_item.tscn").instantiate()
		item.set_up(name, i)
		grid.add_child(item)



func _on_button_pressed():
	if grid.visible == false:
		grid.visible = true
	else :
		grid.visible = false
