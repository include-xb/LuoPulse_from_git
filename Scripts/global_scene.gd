extends Node


@onready var hit_audio_player: AudioStreamPlayer = $"打击音效"

@onready var ui_audio_player: AudioStreamPlayer = $"UI音效"

@onready var bgm_player: AudioStreamPlayer = $"背景音乐"



# 随机 背景图和歌曲
func _set_random_msc() -> void:
	bgm_player.stream_paused = true
	var chart_list: Array
	
	# 为了删掉前面的曲包名
	var pack_name_list: Array
	
	for i in RunningData.pack_list:
		for j in RunningData.pack_list[i]:
			chart_list.append("/" + i + "/" + j)
			pack_name_list.append(i)
	
	var random_index: int = randi_range(0, len(chart_list) - 1)
	var random_chart_name: String = chart_list[random_index]
	var random_cover_path: String = Constant.ROOT_PATH + random_chart_name + "/cover.png"
	var random_audio_path: String = Constant.ROOT_PATH + random_chart_name + "/audio.mp3"
	
	RunningData.random_cover_path = random_cover_path
	RunningData.random_audio_path = random_audio_path
	RunningData.random_chart_name = random_chart_name.trim_prefix("/" + pack_name_list[chart_list.find(random_chart_name)] + "/")

	GlobalScene.bgm_player.stream = load(random_audio_path)
	GlobalScene.bgm_player.play()
	
	bgm_player.stream_paused = false
