extends Control


# 难度选择
@onready var diffic_degree = $Right/InfoDiffi/DifficultyArea/DifficultyDegree

# 简单 中等 困难
@onready var tip_lable = $Right/InfoDiffi/DifficultyArea/TipLable

@onready var msc_title = $Right/MscTitleLable

@onready var msc_info = $Right/InfoDiffi/InfoArea/InfoTextbox/MscInfo

# 简单 中等 困难
var tip_text : String


func _ready():
	GlobalScene.init()


@warning_ignore("unused_parameter")
func _process(delta):
	
	"""
	--------------------------------------------- 待开发 ---------------------------------------
	if diffic_degree.text == 1:
		tip_text = " 简单 EASY "
	if diffic_degree.text == 2:
		tip_text = " 中等 SECONDARY "
	if diffic_degree.text == 3:
		tip_text = " 困难 HARD "
	
	tip_lable.text = tip_text
	"""
	pass


# 返回主菜单 按钮在左上角
func _on_home_button_button_down():
	GlobalScene.play_click_audio()
	get_tree().change_scene_to_file("res://Scene/VisualScene/start_scene.tscn")


# 开始游戏 按钮在右下角
func _on_start_button_button_down():
	GlobalScene.play_click_audio()
	
	# 保存选择的信息
	GlobalScene.saved_difficulty = diffic_degree.value
	GlobalScene.selected_msc_title = msc_title.text
	
	# 如果没有选择
	if msc_info.text == "选择歌曲":
		# print("no selecting")
		return
	
	# 转入游戏场景
	get_tree().change_scene_to_file("res://Scene/VisualScene/play_scene.tscn")


@warning_ignore("unused_parameter")
func _on_difficulty_degree_value_changed(value):
	GlobalScene.play_click_audio()
