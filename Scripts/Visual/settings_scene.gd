extends Control


func _ready():
	pass

func _on_back_button_pressed():
	_safe_cfg_data()
	get_tree().change_scene_to_file("res://Scenes/Visual/hub_scene.tscn")

# 用户设置持久化
func _safe_cfg_data() -> void:
	var config: Dictionary = {
		"speed": RunningData.speed,
		"volume": RunningData.volume,
		"bglight": RunningData.bglight
	}
	var cfgFile: FileAccess = FileAccess.open("user://config.json", FileAccess.WRITE)
	cfgFile.store_string(JSON.stringify(config))
	cfgFile.close()
