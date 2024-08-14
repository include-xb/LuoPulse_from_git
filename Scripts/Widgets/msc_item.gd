extends Control

func set_up(packName: String, mscName: String) -> void:
	var path: String = RunningData.rootMscPath + "/" + packName + "/" + mscName + "/"
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
	get_tree().change_scene_to_file("res://Scenes/Visual/play_scnen.tscn")
