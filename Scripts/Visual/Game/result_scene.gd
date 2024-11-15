extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var path: String = RunningData.selected_msc["path"]
	var chart_name: String = RunningData.selected_msc["name"]
	
	$Background.texture = load(path + "/cover.png")
	$Info/VBoxContainer/ChartNameLabel.text = chart_name
	$Info/VBoxContainer/StaffLabel.text = Utils.get_short_artists_list(path)
	$Score/VBoxContainer/ScoreLabel.text = str(RunningData.score)
	$Score/VBoxContainer/GridContainer/Pure.text = "PURE" + str(RunningData.pure_count)
	$Score/VBoxContainer/GridContainer/Perfect.text = "PERFEXT" + str(RunningData.perfect_count)
	$Score/VBoxContainer/GridContainer/Great.text = "GREAT" + str(RunningData.great_count)
	$Score/VBoxContainer/GridContainer/Good.text = "GOOD" + str(RunningData.good_count)
	$Score/VBoxContainer/GridContainer/Miss.text = "MISS" + str(RunningData.miss_count)
	

func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Visual/Game/game_scene.tscn")

func _on_next_button_pressed() -> void:
	SceneChanger.change_scene("res://Scenes/Visual/Select/mselect_scene.tscn")
