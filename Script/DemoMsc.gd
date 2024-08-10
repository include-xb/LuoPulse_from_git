extends Control

class_name DemoMsc

# 右边容器中的标题
@onready var msc_title_label = $"../../../../Right/MscTitleLabel"

# 音乐列表中歌曲标题
@onready var msc_title = $MscTitle

# 右边容器中显示歌曲详细信息的标签
@onready var msc_info = $"../../../../Right/InfoDiffi/InfoArea/InfoTextbox/MscInfo"

# 歌曲封面
@onready var bk_img = $"../../../../TextureRect"

@onready var score_title = $ScoreTitle


func set_score() -> void:
	# 记录歌曲分数的文件
	var file_path = GlobalScene.saved_msclist_path + msc_title.text + "/" + "score.txt"
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	# 未打开文件, 分数设 0
#	if file == null or !file.is_open():
#		score_title.text = str(0)
#		return
#
#	if file.is_open():
#		var data = file.get_line()
#		score_title.text = data
	
	if (file != null and file.is_open()):
		var data = file.get_line()
		score_title.text = data
	else:
		score_title.text = str(0)

	file.close()


func _on_info_button_button_down():
	
	GlobalScene.play_click_audio()
	
	# 加载歌曲封面图
	bk_img.texture = ImageTexture.create_from_image(
		Image.load_from_file(
			GlobalScene.saved_msclist_path + msc_title.text + "/cover.png"
		)
	)
	
	# 如果加载失败使用这一张图
	if bk_img.texture == null:
		bk_img.texture = load(GlobalScene.default_msc_cover_path)
	
	# 写入全局变量
	GlobalScene.selected_msc_cover = bk_img.texture
	
	msc_title_label.text = msc_title.text
	msc_info.text = ""	# 清空显示歌曲详细信息的标签中的内容
	
	# 打开记录歌曲详细信息的文件
	var file = FileAccess.open(
		GlobalScene.saved_msclist_path + msc_title.text + "/info.txt", 
		FileAccess.READ
	)
	
	if (file != null and file.is_open()):
		var data = file.get_as_text()
		file.close()
		msc_info.text = data
