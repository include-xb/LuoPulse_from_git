extends Control

# 动画
@onready var move_up : AnimationPlayer = $Header/MoveUp

@onready var move_center : AnimationPlayer = $Cover/Center

@onready var last_audio : AudioStreamPlayer2D = $Cover/LastAudio

@onready var background : TextureRect = $TextureRect

@onready var cover : TextureRect = $Cover/TextureRect

@onready var title_label : Label = $Header/HBoxContainer/Center/Info/HBoxContainer/Name


@onready var perfect_plus_label : Label = $"Cover/CoverBody/DOWN/MarginContainer/Count/PPG/Perfect+"

@onready var perfect_label : Label = $Cover/CoverBody/DOWN/MarginContainer/Count/PPG/Perfect

@onready var great_label : Label = $Cover/CoverBody/DOWN/MarginContainer/Count/PPG/Great

@onready var good_label : Label = $Cover/CoverBody/DOWN/MarginContainer/Count/GBM/Good

@onready var bad_label : Label = $Cover/CoverBody/DOWN/MarginContainer/Count/GBM/Bad

@onready var miss_label : Label = $Cover/CoverBody/DOWN/MarginContainer/Count/GBM/Miss

@onready var acc_i_label : Label = $"Cover/CoverBody/UP/Info/MarginContainer/HBoxContainer/Acc/Acc-i"
@onready var acc_f_label : Label = $"Cover/CoverBody/UP/Info/MarginContainer/HBoxContainer/Acc/VBoxContainer2/Acc-f"

@onready var combo_label : Label = $Cover/CoverBody/DOWN/MarginContainer/Count/Combo/Combo


@onready var tip : Label = $Cover/CoverBody/UP/Info/MarginContainer/HBoxContainer/Acc/Tip


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
	
	perfect_plus_label.text = "Perfect+ " 	+ str(GlobalScene.perfect_plus_count)
	perfect_label.text 		= "Perfect " 	+ str(GlobalScene.perfect_count)
	great_label.text 		= "Great " 		+ str(GlobalScene.great_count)
	good_label.text 		= "Good " 		+ str(GlobalScene.good_count)
	bad_label.text 			= "Bad " 		+ str(GlobalScene.bad_count)
	miss_label.text 		= "Miss " 		+ str(GlobalScene.miss_count)
	combo_label.text 		= str(GlobalScene.max_combo)
	
	GlobalScene.average_acc = round(GlobalScene.average_acc * 10000) / 10000
	var acc_i : float = round(GlobalScene.average_acc)
	var acc_f : float = GlobalScene.average_acc - acc_i
	var acc_f_str : String = ""
	if str(acc_f).length() < 4:
		acc_f_str = str(acc_f)
		for i in range(4 - str(acc_f).length()):
			acc_f_str += "0"
	
	acc_i_label.text = str(acc_i)
	acc_f_label.text = acc_f_str
	
	var acc = GlobalScene.average_acc
	if acc == 100:
		tip.text = "∞"
		tip.self_modulate = Color("66ccff")
	elif acc >= 98:
		tip.text = "S+"
	elif acc >= 95:
		tip.text = "S"
	elif acc >= 92:
		tip.text = "A"
	elif acc >= 85:
		tip.text = "B"
	elif acc >= 70:
		tip.text = "C"
	else:
		tip.text = "D"
		tip.self_modulate = Color("acacac")

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
