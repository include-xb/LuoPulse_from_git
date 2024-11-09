# 工具类
extends Node

# 获取短staff列表
func get_short_artists_list(path: String) -> String:
	var info: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(path + "/chart.json"))
	return info["General"]["ShortArtistsList"]

func get_staff_list(path: String) -> String:
	var info: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(path + "/chart.json"))
	return info["General"]["Artist"]

func get_chart_maker(path: String) -> String:
	var info: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(path + "/chart.json"))
	return info["General"]["Creator"]

# 清除计数
func count_clean() -> void:
	RunningData.perfect_count = 0
	RunningData.good_count = 0
	RunningData.missing_count = 0
	RunningData.pure_count = 0
	RunningData.great_count = 0
	RunningData.score = 0
	RunningData.rating = ""
	RunningData.combo = 0
	RunningData.world_timer = 0
	RunningData.decision_area.clear()
