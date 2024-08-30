extends Control

@onready var list: VBoxContainer = $VBoxContainer/MarginContainer2/PackList/VBoxContainer

func _ready() -> void:
	for i in RunningData.pack_list.keys():
		var item: Node = preload("res://Scenes/Widgets/Select/PackItem.tscn").instantiate()
		item.set_up(i)
		list.add_child(item)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Visual/hub_scene.tscn")
