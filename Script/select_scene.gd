extends Control

var packed_demo_msc : PackedScene = preload("res://Scene/WidgetScene/demo_msc.tscn")

@onready var scroll : ScrollContainer = $MarginContainer2/ScrollContainer

@onready var scroll_body : VBoxContainer = $MarginContainer2/ScrollContainer/MscList

@onready var background : TextureRect = $TextureRect

@onready var title_label : Label = $MarginContainer/HBoxContainer/MarginContainer2/Info/HBoxContainer/Name


@onready var artist_label : Label = $PanelContainer/MarginContainer/HBoxContainer/ArtistLabel

@onready var creator_label : Label = $PanelContainer/MarginContainer/HBoxContainer/CreatorLabel

@onready var cover : TextureRect = $MarginContainer3/TextureRect


func set_demo_msc_cover(msc_title : String):
	var path : String = GlobalScene.root_msc_path + msc_title + "/"
	
	if FileAccess.file_exists(path + "cover.png"):
		cover.texture = load(path + "cover.png")
		background.texture = load(path + "cover.png")
	else:
		cover.texture = load("res://Resource/Img/17.png")
		background.texture = load("res://Resource/Img/17.png")
	
	title_label.text = msc_title
	
	GlobalScene.json_path = path + msc_title + ".json"
	if not FileAccess.file_exists(GlobalScene.json_path):
		print("文件 <" + GlobalScene.json_path + "> 不存在")
		return
	var json_file = FileAccess.open(GlobalScene.json_path, FileAccess.READ)
	GlobalScene.json_string = json_file.get_as_text()
	GlobalScene.parsed_json = JSON.parse_string(GlobalScene.json_string)
	
	artist_label.text = GlobalScene.parsed_json.General.Artist
	creator_label.text = "制谱 " + GlobalScene.parsed_json.General.Creator
	
	print(artist_label.text)
	print(creator_label.text)



func _ready():
	# demo_cover.visible = false
	scroll.scroll_vertical = 1
	
	for item in GlobalScene.msc_list + GlobalScene.individual_msc_list:
		print(GlobalScene.root_msc_path + item)
		
		var instanced_demo_msc : MarginContainer = packed_demo_msc.instantiate()
		scroll_body.add_child(instanced_demo_msc)
		instanced_demo_msc.set_demo_msc(item)


func _input(event : InputEvent):
	##### INFO: debug
	if Input.is_key_pressed(KEY_Q):
		print(scroll.scroll_vertical, 
			"/", 
			scroll.get_v_scroll_bar().max_value - scroll_body.get_end().y
		)
	#####
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and scroll.scroll_vertical <= 0:
			var last_child = scroll_body.get_children()[-1]
			scroll_body.move_child(last_child, 0)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and scroll.scroll_vertical == scroll.get_v_scroll_bar().max_value - scroll_body.get_end().y:
			var first_child = scroll_body.get_children()[0]
			scroll_body.move_child(first_child, -1)


# 返回主菜单 按钮在左上角
func _on_home_button_button_down():
	SceneChanger.change_scene("res://Scene/VisualScene/start_scene.tscn")
