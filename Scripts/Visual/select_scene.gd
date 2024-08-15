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
			$Info/CenterContainer/TextureRect/MarginContainer/VBoxContainer/MscName,
			$Info/CenterContainer/TextureRect/MarginContainer/VBoxContainer/ArName,
			$Info/CenterContainer/TextureRect,
			info,
			audioPlayer
		)
		listView.add_child(item)

##############################
# 返回
func _on_info_gui_input(event):
	print("返回歌单")
	if event is InputEventScreenTouch and event.pressed:
		pass


# 开始
func _on_texture_rect_gui_input(event):
	print("开始")
	if event is InputEventScreenTouch and event.pressed:
		pass
