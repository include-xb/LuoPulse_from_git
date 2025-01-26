extends Control


@onready var bgmplayer_title: Label = $BGMPlayer/PanelContainer/VBoxContainer/title/msctitle


func _ready():
	# 设置随机到的背景
	# ATTENTION: 随机到的歌曲音频已经在 start_scene 开始播放
	
	$Background.texture = load(RunningData.random_cover_path)
	bgmplayer_title.text = RunningData.random_chart_name
	
	# 从保存的配置文件读取用户名
	$UserInfo/HBoxContainer/UserNameLabel.text = RunningData.user_name
	
	## 头像自动设置
	#if Constant.PRODUCTORS_HEAD_PORTRAIT.has(RunningData.user_name):
		#$UserInfo/HBoxContainer/HeadPortrait.texture = load(Constant.PRODUCTORS_HEAD_PORTRAIT[RunningData.user_name])
	
	$Title/VBoxContainer/VerName.text = Constant.VERSION_NAME
	
	# 头像
	if Constant.PRODUCTORS_PORTRAIT_LINK.has(RunningData.user_name):
		var http_request = HTTPRequest.new()
		add_child(http_request)
		http_request.connect("request_completed", _on_image_request_completed)
		http_request.request(Constant.PRODUCTORS_PORTRAIT_LINK[RunningData.user_name])


@warning_ignore("unused_parameter")
func _on_image_request_completed(result, response_code, headers, body : PackedByteArray):
	if response_code == 200:
		var image = Image.new()
		if image.load_jpg_from_buffer(body) == OK:
			var texture = ImageTexture.create_from_image(image)
			
			$UserInfo/HBoxContainer/HeadPortrait.texture = texture
			
		else:
			print("图像加载失败")
	else:
		print("图像请求失败")




func _on_start_button_pressed():
	SceneChanger.change_scene("res://Scenes/Visual/Select/pselect_scene.tscn")


func _on_settings_btn_pressed():
	SceneChanger.change_scene("res://Scenes/Visual/Settings/settings_scene.tscn")


func _on_change_pressed() -> void:
	GlobalScene._set_random_msc()
	
	$Background.texture = load(RunningData.random_cover_path)
	bgmplayer_title.text = RunningData.random_chart_name
