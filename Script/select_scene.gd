extends Control

var packed_demo_msc : PackedScene = preload("res://Scene/WidgetScene/demo_msc.tscn")

# 滚动容器本身
@onready var scroll : ScrollContainer = $MarginContainer2/ScrollContainer

# 滚动容器主体
@onready var scroll_body : VBoxContainer = $MarginContainer2/ScrollContainer/MscList

# 模糊后的背景
@onready var background : TextureRect = $TextureRect

# 窗口顶部中间的歌曲标题
@onready var title_label : Label = $MarginContainer/HBoxContainer/MarginContainer2/Info/HBoxContainer/Name

# 作词作曲 演唱 等信息
@onready var artist_label : Label = $MarginContainer3/PanelContainer/MarginContainer/HBoxContainer/ArtistLabel

# 谱面制作者
@onready var creator_label : Label = $MarginContainer3/PanelContainer/MarginContainer/HBoxContainer/CreatorLabel

# 窗口右半部分的歌曲封面
@onready var cover : TextureRect = $MarginContainer3/TextureRect

# 歌曲预播放
@onready var audio_preplayer : AudioStreamPlayer2D = $MarginContainer3/AudioPreplayer2D

# 点击开始按钮后, 歌单向左移, 封面居中
# 拿到歌单节点
@onready var msc_list : MarginContainer = $MarginContainer2

# 歌单向左边飞啊飞啊的动画播放
@onready var move_left_animation : AnimationPlayer = $MarginContainer2/MoveLeft

# 封面向中间挤呀挤呀挤到中间填满整个窗口的动画播放
@onready var center_animation : AnimationPlayer = $MarginContainer3/Center


func set_demo_msc_cover(msc_title : String):
	var path : String = GlobalScene.root_msc_path + msc_title + "/"
	
	title_label.text = msc_title
	GlobalScene.selected_msc_title = msc_title
	
	if FileAccess.file_exists(path + "cover.png"):
		cover.texture = load(path + "cover.png")
		background.texture = load(path + "cover.png")
	else:
		cover.texture = load("res://Resource/Img/17.png")
		background.texture = load("res://Resource/Img/17.png")
	GlobalScene.selected_msc_cover = cover.texture
	
	var audio_path : String = path + "audio.mp3"
	if not FileAccess.file_exists(audio_path):
		print("文件 <" + audio_path + "> 不存在")
		return
	GlobalScene.selected_stream = load(audio_path)
	audio_preplayer.stream = load(audio_path)
	audio_preplayer.play()
	
	GlobalScene.json_path = path + msc_title + ".json"
	if not FileAccess.file_exists(GlobalScene.json_path):
		print("文件 <" + GlobalScene.json_path + "> 不存在")
		return
	var json_file = FileAccess.open(GlobalScene.json_path, FileAccess.READ)
	GlobalScene.json_string = json_file.get_as_text()
	GlobalScene.parsed_json = JSON.parse_string(GlobalScene.json_string)
	
	artist_label.text = GlobalScene.parsed_json.General.Artist
	creator_label.text = "制谱 " + GlobalScene.parsed_json.General.Creator + "\n "
	
	print(artist_label.text)
	print(creator_label.text)


func _ready():
	# demo_cover.visible = false
	scroll.scroll_vertical = 1
	
	move_left_animation.play("RESET")
	center_animation.play("RESET")
	
	for item in GlobalScene.msc_list + GlobalScene.individual_msc_list:
		print(GlobalScene.root_msc_path + item)
		
		var instanced_demo_msc : MarginContainer = packed_demo_msc.instantiate()
		scroll_body.add_child(instanced_demo_msc)
		instanced_demo_msc.set_demo_msc(item)


func _input(event : InputEvent):
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


func _on_button_pressed():
	move_left_animation.play("move_left")
	center_animation.play("center")
	await center_animation.animation_finished
	audio_preplayer.stop()
	print("进入 play_scene")
	SceneChanger.change_scene("res://Scene/VisualScene/play_scene.tscn")
