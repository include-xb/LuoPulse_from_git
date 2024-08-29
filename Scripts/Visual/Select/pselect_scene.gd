extends Control

@onready var list: VBoxContainer = $VBoxContainer/MarginContainer2/PanelContainer/PackList/VBoxContainer

func _ready() -> void:
	for i in RunningData.mscPackList.keys():
		var item: Node = preload("res://Scenes/Widgets/Select/PackItem.tscn").instantiate()
		item.set_up(i)
		list.add_child(item)
