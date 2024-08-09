extends Control


# 难度选择
@onready var diffic_degree = $Right/InfoDiffi/DifficultyArea/DifficultyDegree

"""
# 简单 中等 困难
@onready var tip_label = $Right/InfoDiffi/DifficultyArea/TipLabel
"""

@onready var msc_title = $Right/MscTitleLabel

@onready var msc_info = $Right/InfoDiffi/InfoArea/InfoTextbox/MscInfo

"""
# 简单 中等 困难
var tip_text : String = ""
"""

var original_text : String = ""


func _ready():
	GlobalScene.init()
	original_text = msc_info.text


@warning_ignore("unused_parameter")
func _process(delta):
	
	"""
	--------------------------------------------- 待开发 ---------------------------------------
	"""
	pass


# 返回主菜单 按钮在左上角
func _on_home_button_button_down():
	GlobalScene.change_scene_with_audio("res://Scene/VisualScene/start_scene.tscn")


# 开始游戏 按钮在右下角
func _on_start_button_button_down():
	GlobalScene.play_click_audio()
	
	# 如果已选择
	if msc_info.text != original_text:
		# 保存选择的信息
		GlobalScene.saved_difficulty = diffic_degree.value
		GlobalScene.selected_msc_title = msc_title.text
		# 转入游戏场景
		get_tree().change_scene_to_file("res://Scene/VisualScene/play_scene.tscn")


@warning_ignore("unused_parameter")
func _on_difficulty_degree_value_changed(value):
	GlobalScene.play_click_audio()
