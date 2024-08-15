extends Node

var rootMscPath: String = "res://MscList"

var mscPackList: Dictionary

var versionName: String = "v0.1beta"

# 选择歌曲的路径, 指向歌曲文件夹而不是.MP3
var selected_msc_path : String = ""

# 选中歌曲标题
var selected_msc_name : String = ""

# xml文件目录
var xml_path : String = ""

# 音符流速, 玩家可调, 默认 10
var speed : int = 10

# 音频当前的播放时间
var current_audio_time : float = -1.0
