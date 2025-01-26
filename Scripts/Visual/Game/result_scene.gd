extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# 补 0 空位
	var int_part_acc_str: String = str(int(RunningData.accuracy))
	var float_part_acc_str: String = str(RunningData.accuracy - int(RunningData.accuracy)).trim_prefix("0.")
	var int_part_diff: int = 2 - int_part_acc_str.length()
	var float_part_diff: int = 4 - float_part_acc_str.length()
	if int_part_diff != 0:
		int_part_acc_str = "0" + int_part_acc_str
	if float_part_diff != 0:
		var adjust_str: String = ""
		for i in range(float_part_diff):
			adjust_str += "0"
		float_part_acc_str = adjust_str + float_part_acc_str
	
	# 分数结算
	var path: String = RunningData.selected_msc["path"]
	var chart_name: String = RunningData.selected_msc["name"]
	$Background.texture = load(path + "/cover.png")
	$Info/VBoxContainer/ChartNameLabel.text = chart_name
	$Info/VBoxContainer/StaffLabel.text = Utils.get_short_artists_list(path)
	$Score/VBoxContainer/AccLabel.text = int_part_acc_str + "." + float_part_acc_str
	$Score/VBoxContainer/GridContainer/Pure.text = "PURE: " + str(RunningData.pure_count)
	$Score/VBoxContainer/GridContainer/Perfect.text = "PERFECT: " + str(RunningData.perfect_count)
	$Score/VBoxContainer/GridContainer/Great.text = "GREAT: " + str(RunningData.great_count)
	$Score/VBoxContainer/GridContainer/Good.text = "GOOD: " + str(RunningData.good_count)
	$Score/VBoxContainer/GridContainer/Miss.text = "MISS: " + str(RunningData.miss_count)
	

func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Visual/Game/game_scene.tscn")

func _on_next_button_pressed() -> void:
	SceneChanger.change_scene("res://Scenes/Visual/Select/mselect_scene.tscn")
