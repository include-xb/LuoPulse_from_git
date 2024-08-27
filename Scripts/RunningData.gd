extends Node

var rootMscPath: String = "res://MscList"

var mscPackList: Dictionary = { }

var versionName: String = "v1.0beta"

# 选择歌曲的路径, 指向歌曲文件夹而不是.MP3
var selected_msc_path : String = ""

# 选中歌曲标题
var selected_msc_name : String = ""

# 选择歌曲的封面
var selected_msc_cover : Texture

# .mp3 音频流
var audio_stream : AudioStreamMP3

# json文件目录
var json_path : String = ""

# json文件内容
var json_file_data : String = ""

# JSON.parse_string(...) 的返回值
var parsed_json : Dictionary = { }

# 音频当前的播放时间
var current_audio_time : float = -1.0

# 开始后的等待时间
var delay_time : int = -2

# 处于判定区间内的音符
var decision_area : Array = [ ]

# play_scene 中 per/good/miss 的统计
var perfect_count : int = 0
var good_count : int = 0
var missing_count : int = 0

# setting:

var is_auto_play : bool = false

# 音符流速, 玩家可调, 默认 10
var speed : int = 10

var volume : int = 0

var bglight : int = 0


func play_hit_audio():
	$Hit.play()


func count_clean():
	perfect_count = 0
	good_count = 0
	missing_count = 0
