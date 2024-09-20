extends Control

var packed_demo_msc : PackedScene = preload("res://Scene/WidgetScene/demo_msc.tscn")

# 滚动容器本身
@onready var scroll : ScrollContainer = $MscList/ScrollContainer

# 滚动容器主体
@onready var scroll_body : VBoxContainer = $MscList/ScrollContainer/Body

# 模糊后的背景
@onready var background : TextureRect = $TextureRect

# 窗口顶部中间的歌曲标题
@onready var title_label : Label = $Header/HBoxContainer/Center/Info/HBoxContainer/Name

# 作词作曲 演唱 等信息
@onready var artist_label : Label = $Cover/Info/MarginContainer/HBoxContainer/ArtistLabel

# 谱面制作者
@onready var creator_label : Label = $Cover/Info/MarginContainer/HBoxContainer/VBoxContainer/CreatorLabel

# 曲绘
@onready var illustrator_label : Label = $Cover/Info/MarginContainer/HBoxContainer/VBoxContainer/IllustratorLabel

# 窗口右半部分的歌曲封面
@onready var cover : TextureRect = $Cover/TextureRect

# 歌曲预播放
@onready var audio_preplayer : AudioStreamPlayer2D = $Cover/AudioPreplayer2D

# 点击开始按钮后, 歌单向左移, 封面居中
# 拿到歌单节点
@onready var msc_list : MarginContainer = $MscList

# 歌单向左边飞啊飞啊的动画播放
@onready var move_left_animation : AnimationPlayer = $MscList/MoveLeft

# 封面向中间挤呀挤呀挤到中间填满整个窗口的动画播放
@onready var center_animation : AnimationPlayer = $Cover/Center

# 标题栏向上面飘呀飘呀的动画播放
@onready var move_up_animation : AnimationPlayer = $Header/MoveUp


var selectable_list : Array[String] = [ ]

var dir : DirAccess

var dir_name : String


func set_demo_msc_cover(msc_title : String):
	var path : String = GlobalScene.root_msc_path + msc_title + "/"
	
	title_label.text = msc_title
	GlobalScene.selected_msc_title = msc_title
	
	if FileAccess.file_exists(path + "cover.png"):
		cover.texture = ImageTexture.create_from_image(
			Image.load_from_file(
				path + "cover.png"
			)
		)
		background.texture = cover.texture
	elif FileAccess.file_exists(path + "cover.jpg"):
		cover.texture = ImageTexture.create_from_image(
			Image.load_from_file(
				path + "cover.jpg"
			)
		)
		background.texture = cover.texture
	else:
		cover.texture = load("res://Resource/Img/17.png")
		background.texture = cover.texture
	
	# artist_label.text = GlobalScene.selected_packed_name
	"""
	GlobalScene.selected_msc_cover = cover.texture
	
	var audio_path : String = path + "audio.mp3"
	if not FileAccess.file_exists(audio_path):
		print("文件 <" + audio_path + "> 不存在")
		# artist_label.text = "文件 <" + audio_path + "> 不存在"
	else:
		var audio_file = FileAccess.open(audio_path, FileAccess.READ)
		var sound = AudioStreamMP3.new()
		sound.data = audio_file.get_buffer(audio_file.get_length())
		audio_preplayer.stream = sound
		
		if audio_preplayer.stream == null:
			audio_preplayer.stream = load(audio_path)
		
		GlobalScene.selected_stream = audio_preplayer.stream
		audio_preplayer.stream = GlobalScene.selected_stream
		audio_preplayer.play()
	
	GlobalScene.json_path = path + "chart.json"
	if not FileAccess.file_exists(GlobalScene.json_path):
		print("文件 <" + GlobalScene.json_path + "> 不存在")
		# creator_label.text = "文件 <" + GlobalScene.json_path + "> 不存在"
	else:
		var json_file = FileAccess.open(GlobalScene.json_path, FileAccess.READ)
		GlobalScene.json_string = json_file.get_as_text()
		GlobalScene.parsed_json = JSON.parse_string(GlobalScene.json_string)
	
		artist_label.text = GlobalScene.parsed_json.General.Artist
		creator_label.text = "制谱 " + GlobalScene.parsed_json.General.Creator
		illustrator_label.text = "曲绘/PV " + GlobalScene.parsed_json.General.Illustrator
	"""


func _ready():
	get_tree().paused = false
	
	scroll.scroll_vertical = 1
	
	move_up_animation.play("RESET")
	move_left_animation.play("RESET")
	center_animation.play("RESET")
	
	for item in GlobalScene.msc_list:
		print(GlobalScene.root_msc_path + item)
		
		var instanced_demo_msc : MarginContainer = packed_demo_msc.instantiate()
		scroll_body.add_child(instanced_demo_msc)
		instanced_demo_msc.set_demo_msc(item)
	
	set_demo_msc_cover(GlobalScene.selected_msc_title)
	move_up_animation.play_backwards("move_up")
	move_left_animation.play_backwards("move_left")
	center_animation.play_backwards("center")
	
	title_label.text = "洛之动脉"


func _input(event : InputEvent):
	if GlobalScene.selected_demo_msc != null:
		GlobalScene.selected_demo_msc.modulate = Color("66ccff")
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and scroll.scroll_vertical <= 0:
			var last_child = scroll_body.get_children()[-1]
			scroll_body.move_child(last_child, 0)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and scroll.scroll_vertical == scroll.get_v_scroll_bar().max_value - scroll_body.get_end().y:
			var first_child = scroll_body.get_children()[0]
			scroll_body.move_child(first_child, -1)
	
	if Input.is_action_just_pressed("Pause"):
		_on_home_button_pressed()


# 返回主菜单 按钮在左上角
func _on_home_button_pressed():
	SceneChanger.change_scene("res://Scene/VisualScene/hub_scene.tscn")


func _on_button_pressed():
	"""
	move_up_animation.play("move_up")
	move_left_animation.play("move_left")
	center_animation.play("center")
	
	await center_animation.animation_finished
	audio_preplayer.stop()
	"""
	
	print("进入 select_scene")
	GlobalScene.selectable_msc_path = GlobalScene.root_msc_path + title_label.text + "/"
	
	var dir = DirAccess.open(GlobalScene.selectable_msc_path)
	# 读取歌单内容
	if dir:
		dir.list_dir_begin()
		dir_name = dir.get_next()
		while dir_name != "":
			if dir.current_is_dir():
				selectable_list.append(dir_name)
			dir_name = dir.get_next()
	print("内置歌单: ", selectable_list)
	print("自定义歌单: ", GlobalScene.individual_msc_list)
	GlobalScene.selectable_list = selectable_list
	
	SceneChanger.change_scene("res://Scene/VisualScene/select_scene.tscn")


