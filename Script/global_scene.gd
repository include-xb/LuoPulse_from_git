extends Node2D

# 全局变量

# 播放 UI 点击音效
@onready var click_audio_player = $UIClick

# 播放音符点击音效
@onready var hit_audio_player = $Hit

# 用户名
var user_name : String = "user"

# 曲包目录
var root_msc_path : String = "res://MscList"

# 自定义曲包目录
var individual_msc_path : String = ""

# 歌单列表
var msc_list : Array[String] = [ ]

# 自定义歌单列表
var individual_msc_list : Array[String] = [ ]
