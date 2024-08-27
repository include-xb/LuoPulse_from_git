extends Control

@onready var listView: VBoxContainer = $VBoxContainer/MarginContainer2/PanelContainer/ScrollContainer/ListView
@onready var info: ColorRect = $Info
@onready var audioPlayer: AudioStreamPlayer = $AudioStreamPlayer

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Visual/hub_scene.tscn")

func _ready():
	info.visible = false
	
	for i in RunningData.mscPackList.keys():
		var item: Node = preload("res://Scenes/Widgets/pack_item.tscn").instantiate()
		item.set_up(
			i, 
			RunningData.mscPackList[i], 
			$Info/CenterContainer/TextureRect/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/MscName,
			$Info/CenterContainer/TextureRect/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/ArName,
			$Info/CenterContainer/TextureRect,
			info,
			audioPlayer
		)
		listView.add_child(item)


func _on_close_button_pressed() -> void:
	audioPlayer.stop()
	print("返回歌单")
	info.visible = false


func _on_start_button_pressed() -> void:
	audioPlayer.stop()
	print("开始")
	get_tree().change_scene_to_file("res://Scenes/Visual/play_scene.tscn")
