extends Control

# 指向歌曲文件夹路径
var path : String = ""

# 歌曲名称
var msc_name : StringName = ""

func set_up(packName: String, mscName: String) -> void:
	path = RunningData.rootMscPath + "/" + packName + "/" + mscName + "/"
	
	msc_name = mscName
	$VBoxContainer/MscNameLabel.text = mscName 
	
	$VBoxContainer/ArLabel.text = FileAccess.get_file_as_string(
		path + "info.txt"
	)
	$TextureRect.texture = ImageTexture.create_from_image(
		Image.load_from_file(
			path + "cover.png"
		)
	)

# 玩家点击了选择的歌曲, 进入下一场景
func _on_button_pressed():
	print("select finished")
	RunningData.selected_msc_path = path
	RunningData.selected_msc_name = msc_name
	
	
	
	RunningData.xml_path = path + RunningData.selected_msc_name + ".lp"		# XX/XX/pack_name/msc_name/msc_name.lp
	
	# print(path + RunningData.selected_msc_name + ".lp")
	# print(FileAccess.get_file_as_string(path + RunningData.selected_msc_name + ".lp"))
	
	get_tree().change_scene_to_file("res://Scenes/Visual/play_scnen.tscn")
