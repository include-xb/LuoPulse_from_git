extends Control


func _ready():
	GlobalScene.set_volume(GlobalScene.default_volume)
	# 开始时关闭游戏的暂停状态
	get_tree().paused = false


# 开始游戏按钮 实际上是切换到选择歌曲场景
func _on_start_button_button_down():
	GlobalScene.change_scene_with_audio("res://Scene/VisualScene/select_scene.tscn")

# 设置按钮
func _on_setting_button_button_down():
	GlobalScene.change_scene_with_audio("res://Scene/VisualScene/setting_scene.tscn")

# 关于按钮
func _on_about_button_button_down():
	GlobalScene.change_scene_with_audio("res://Scene/VisualScene/about_scene.tscn")
