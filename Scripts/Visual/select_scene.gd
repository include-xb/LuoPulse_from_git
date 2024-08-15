extends Control

@onready var listView: VBoxContainer = $VBoxContainer/MarginContainer2/PanelContainer/ScrollContainer/ListView

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Visual/hub_scene.tscn")

func _ready():
	for i in RunningData.mscPackList.keys():
		var item: Node = preload("res://Scenes/Widgets/pack_item.tscn").instantiate()
		item.set_up(i, RunningData.mscPackList[i])
		listView.add_child(item)
