extends Control

func set_up(packName: String, mscName: String) -> void:
	var path: String = RunningData.rootMscPath + "/" + packName + "/" + mscName + "/"
	$VBoxContainer/MscNameLabel.text = mscName 
	$VBoxContainer/ArLabel.text = FileAccess.get_file_as_string(
		path + "info.txt"
	)
	$TextureRect.texture = load(path + "cover.png")
