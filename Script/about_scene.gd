extends Control


# 点击主页面按钮
func _on_home_button_button_down():
	GlobalScene.change_scene_with_audio("res://Scene/VisualScene/start_scene.tscn")
