extends Control


# 误差调整
@onready var adjust = $ScrollContainer/HBoxContainer/Adjust/AdjustSpinBox

# 音量设置
@onready var volume = $ScrollContainer/HBoxContainer/Volume/VolumeHSlider

# 歌单路径
@onready var path = $ScrollContainer/HBoxContainer/Path/PathTextEdit


# 恢复默认
func default_setting():
	adjust.value = GlobalScene.default_adjustment
	volume.value = GlobalScene.default_volume
	path.text = GlobalScene.default_msclist_path
	
	GlobalScene.saved_adjustment = GlobalScene.default_adjustment
	GlobalScene.saved_volume = GlobalScene.default_volume
	GlobalScene.saved_msclist_path = GlobalScene.default_msclist_path


func _ready():
	adjust.value = GlobalScene.saved_adjustment
	volume.value = GlobalScene.saved_volume
	path.text = GlobalScene.saved_msclist_path


# 按下恢复默认按钮
func _on_default_button_button_down():
	GlobalScene.play_click_audio()
	default_setting()


# 保存更改按钮
func _on_save_button_button_down():
	GlobalScene.set_volume(volume.value)
	
	# 检查路径最后是否有 /
	if path.text[path.text.length() - 1] != "/" and path.text[path.text.length() - 1] != "\\":
		path.text += "/"
	
	GlobalScene.saved_adjustment = adjust.value
	GlobalScene.saved_volume = volume.value
	GlobalScene.saved_msclist_path = path.text
	GlobalScene.change_scene_with_audio("res://Scene/VisualScene/start_scene.tscn")


func _on_volume_h_slider_value_changed(value):
	GlobalScene.set_volume(value)
	GlobalScene.play_click_audio()


@warning_ignore("unused_parameter")
func _on_adjust_spin_box_value_changed(value):
	GlobalScene.play_click_audio()
