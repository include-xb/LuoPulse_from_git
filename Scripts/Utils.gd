extends Node

# 获取短staff列表
func get_artists(path: String) -> String:
	var info: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(path + "/info.json"))
	return info["shortArtistsList"]


# 清除计数
func count_clean() -> void:
	RunningData.perfect_count = 0
	RunningData.good_count = 0
	RunningData.missing_count = 0
