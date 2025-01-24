extends Control


@onready var bgmplayer_title: Label = $BGMPlayer/PanelContainer/VBoxContainer/title/msctitle


func _ready():
	# 设置随机到的背景
	# ATTENTION: 随机到的歌曲音频已经在 start_scene 开始播放
	
	$Background.texture = load(RunningData.random_cover_path)
	bgmplayer_title.text = RunningData.random_chart_name
	
	# 从保存的配置文件读取用户名
	$UserInfo/HBoxContainer/UserNameLabel.text = RunningData.user_name
	# 头像自动设置
	if Constant.PRODUCTORS_HEAD_PORTRAIT.has(RunningData.user_name):
		$UserInfo/HBoxContainer/HeadPortrait.texture = load(Constant.PRODUCTORS_HEAD_PORTRAIT[RunningData.user_name])
	
	$Title/VBoxContainer/VerName.text = Constant.VERSION_NAME
	

func _on_start_button_pressed():
	SceneChanger.change_scene("res://Scenes/Visual/Select/pselect_scene.tscn")


func _on_settings_btn_pressed():
	SceneChanger.change_scene("res://Scenes/Visual/Settings/settings_scene.tscn")


func _on_change_pressed() -> void:
	GlobalScene._set_random_msc()
	
	$Background.texture = load(RunningData.random_cover_path)
	bgmplayer_title.text = RunningData.random_chart_name
