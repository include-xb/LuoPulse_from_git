extends Control


func _ready():
	pass

# 返回主菜单 按钮在左上角
func _on_home_button_button_down():
	SceneChanger.change_scene("res://Scene/VisualScene/start_scene.tscn")


# 开始游戏 按钮在右下角
func _on_start_button_button_down():
	GlobalScene.play_click_audio()
