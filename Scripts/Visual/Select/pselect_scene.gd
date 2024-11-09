extends Control

@onready var list: VBoxContainer = $VBoxContainer/MarginContainer2/PackList/VBoxContainer

func _ready() -> void:
	$Background.texture = load(RunningData.random_cover_path)
	for i in RunningData.pack_list.keys():
		var item: Node = preload("res://Scenes/Widgets/Select/PackItem.tscn").instantiate()
		item.set_up(i)
		list.add_child(item)


func _on_button_pressed() -> void:
	SceneChanger.change_scene("res://Scenes/Visual/hub_scene.tscn")
