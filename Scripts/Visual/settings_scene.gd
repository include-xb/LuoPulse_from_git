extends Control


func _ready():
	pass

func _on_back_button_pressed():
	_safe_cfg_data()
	SceneChanger.change_scene("res://Scenes/Visual/hub_scene.tscn")

# 用户设置持久化
func _safe_cfg_data() -> void:
	if RunningData.temp_user_name != "" and RunningData.temp_user_name != null:
		RunningData.user_name = RunningData.temp_user_name
	RunningData.temp_user_name = ""
	var config: Dictionary = {
		"speed": RunningData.speed,
		"volume": RunningData.volume,
		"bglight": RunningData.bglight,
		"user_name": RunningData.user_name
	}
	var cfgFile: FileAccess = FileAccess.open("user://config.json", FileAccess.WRITE)
	cfgFile.store_string(JSON.stringify(config))
	cfgFile.close()
