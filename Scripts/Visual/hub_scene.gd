extends Control

func _ready():
	$Background.texture = load(RunningData.random_cover_path)
	# 从保存的配置文件读取用户名
	$UserInfo/HBoxContainer/UserNameLabel.text = RunningData.user_name
	print(RunningData.user_name)
	# 头像自动设置
	if Constant.PRODUCTORS_HEAD_PORTRAIT.has(RunningData.user_name):
		print("hit")
		$UserInfo/HBoxContainer/HeadPortrait.texture = load(Constant.PRODUCTORS_HEAD_PORTRAIT[RunningData.user_name])
	
	$Title/VBoxContainer/VerName.text = Constant.VERSION_NAME

func _on_start_button_pressed():
	SceneChanger.change_scene("res://Scenes/Visual/Select/pselect_scene.tscn")


func _on_settings_btn_pressed():
	SceneChanger.change_scene("res://Scenes/Visual/Settings/settings_scene.tscn")
