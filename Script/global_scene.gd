extends Control

# 全局变量


# 播放 UI 点击音效
@onready var click_audio_player = $UIClick

# 播放音符点击音效
@onready var hit_audio_player = $Hit

# 版本
var version : String = "pc3.1.0"

# 用户名
var user_name : String = "user"

# 最大用户名长度
var max_user_name_length : int = 15

# 曲包目录
var root_msc_path : String = "res://MscList/"

# 自定义曲包目录
var individual_msc_path : String = ""

# 歌单列表
var msc_list : Array[String] = [ ]

# 自定义歌单列表
var individual_msc_list : Array[String] = [ ]


var json_path : String = ""

var json_string : String = ""

var parsed_json : Dictionary = { }

