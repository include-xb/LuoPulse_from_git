extends Control

# 动画
@onready var move_up : AnimationPlayer = $Header/MoveUp

@onready var move_center : AnimationPlayer = $Cover/Center

@onready var last_audio : AudioStreamPlayer2D = $Cover/LastAudio

@onready var background : TextureRect = $TextureRect

@onready var cover : TextureRect = $Cover/TextureRect

@onready var title_label : Label = $Header/HBoxContainer/Center/Info/HBoxContainer/Name

@onready var perfect_label : Label = $Cover/Info/MarginContainer/HBoxContainer/Count/PG/Perfect

@onready var good_label : Label = $Cover/Info/MarginContainer/HBoxContainer/Count/PG/Good

@onready var miss_label : Label = $Cover/Info/MarginContainer/HBoxContainer/Count/MC/Miss

@onready var combe_label : Label = $Cover/Info/MarginContainer/HBoxContainer/Count/MC/Combe




func set_demo_msc_cover(msc_title : String):
	var path : String = GlobalScene.selectable_msc_path + msc_title + "/"
	
	
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
	
	GlobalScene.selected_msc_cover = cover.texture
	
	var audio_path : String = path + "audio.mp3"
	if not FileAccess.file_exists(audio_path):
		# print("文件 <" + audio_path + "> 不存在")
		# artist_label.text = "文件 <" + audio_path + "> 不存在"
		pass
	else:
		var audio_file = FileAccess.open(audio_path, FileAccess.READ)
		var sound = AudioStreamMP3.new()
		sound.data = audio_file.get_buffer(audio_file.get_length())
		last_audio.stream = sound
		
		if last_audio.stream == null:
			last_audio.stream = load(audio_path)
		
		GlobalScene.selected_stream = last_audio.stream
		last_audio.stream = GlobalScene.selected_stream
		last_audio.play()
	
	perfect_label.text = "perfect " + str(GlobalScene.perfect_count)
	good_label.text = "good " + str(GlobalScene.good_count)
	miss_label.text = "miss " + str(GlobalScene.miss_count)
	combe_label.text = "max combe " + str(GlobalScene.max_combe)


func _ready():
	set_demo_msc_cover(GlobalScene.selected_msc_title)
	
	move_center.play_backwards("center")
	move_up.play_backwards("move_up")
	

# 返回歌单列表
func _on_home_button_pressed():
	SceneChanger.change_scene("res://Scene/VisualScene/select_scene.tscn")


# 重新开始
func _on_retry_button_pressed():
	SceneChanger.change_scene("res://Scene/VisualScene/play_scene.tscn")
