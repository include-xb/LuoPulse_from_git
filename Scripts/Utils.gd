# 工具类
extends Node

# 获取短staff列表
func get_short_artists_list(path: String) -> String:
	var info: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(path + "/chart.json"))
	return info["General"]["ShortArtistsList"]


# 获取staff列表
func get_staff_list(path: String) -> String:
	var info: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(path + "/chart.json"))
	return info["General"]["Artist"]


# 获取谱面制作者
func get_chart_maker(path: String) -> String:
	var info: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(path + "/chart.json"))
	return info["General"]["Creator"]
