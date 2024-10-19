extends Control

@onready var timeLabel: Label = $AppTile/MarginContainer/HBoxContainer/TimeLabel

func _ready():
	$AppTile/MarginContainer/HBoxContainer/Label.text = "Luo Pulse " + Constant.VERSION_NAME
	# 从保存的配置文件读取用户名
	$UserInfo/HBoxContainer/UserNameLabel.text = RunningData.user_name
	print(RunningData.user_name)
	# 头像自动设置
	if Constant.PRODUCTORS_HEAD_PORTRAIT.has(RunningData.user_name):
		print("hit")
		$UserInfo/HBoxContainer/HeadPortrait.texture = load(Constant.PRODUCTORS_HEAD_PORTRAIT[RunningData.user_name])

func _process(_delta):
	var time_dict: Dictionary = Time.get_time_dict_from_system()
	var minute: String = str(time_dict["minute"])
	var second: String = str(time_dict["second"])
	
	if minute.length() == 1:
		minute = "0" + minute
	
	if second.length() == 1:
		second = "0" + second
	
	var time: String = str(time_dict["hour"]) + ":" + minute + ":" + second
	timeLabel.text = time


func _on_start_button_pressed():
	SceneChanger.change_scene("res://Scenes/Visual/Select/pselect_scene.tscn")


func _on_notice_btn_pressed():
	SceneChanger.change_scene("res://Scenes/Visual/notice_scene.tscn")


func _on_settings_btn_pressed():
	SceneChanger.change_scene("res://Scenes/Visual/Settings/settings_scene.tscn")
