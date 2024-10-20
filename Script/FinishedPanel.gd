extends Panel

@onready var tilte_label = $TitleLabel

@onready var speed_box = $InfoVBoxContainer/SPEEDHBoxContainer/SpeedLineEdit

@onready var perfect_box = $InfoVBoxContainer/PERFECTHBoxContainer/PerfectLineEdit

@onready var good_box = $InfoVBoxContainer/GOODHBoxContainer/GoodLineEdit

@onready var missing_box = $InfoVBoxContainer/MISSINGHBoxContainer/MissingLineEdit

@onready var score_box = $ScoreHBoxContainer/ScoreLineEdit

func _ready():
	
	# 基本信息的展示
	tilte_label.text = GlobalScene.selected_msc_title
	speed_box.text = "10"
	perfect_box.text = str(GlobalScene.perfect_count)
	good_box.text = str(GlobalScene.good_count)
	missing_box.text =  str(GlobalScene.missing_count)
	
	# 计算分数
	GlobalScene.score = GlobalScene.calc_score()
	score_box.text = str(GlobalScene.score)


func _on_next_button_button_down():

	# 打开计分文件
	var file = FileAccess.open(GlobalScene.saved_msclist_path + GlobalScene.selected_msc_title + "/" + "score.txt", FileAccess.READ_WRITE)
	
	# 文件未正常打开
	if file == null or !file.is_open():
		get_tree().change_scene_to_file("res://Scene/VisualScene/select_scene.tscn")
		return
	
	var data = file.get_line()
	if int(data) <= GlobalScene.score:
		# 重写文件
		file.seek(0)
		file.store_string(str(GlobalScene.score))
	file.close()
	
	GlobalScene.change_scene_with_audio("res://Scene/VisualScene/select_scene.tscn")


# 返回游戏
func _on_back_button_button_down():
	GlobalScene.play_click_audio()
	queue_free()
