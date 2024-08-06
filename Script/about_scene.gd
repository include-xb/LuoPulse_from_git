extends Control


# 点击主页面按钮
func _on_home_button_button_down():
	GlobalScene.play_click_audio()
	get_tree().change_scene_to_file("res://Scene/VisualScene/start_scene.tscn")
