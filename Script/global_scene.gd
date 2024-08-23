extends Control

# 全局变量

# 切换场景
@onready var color_rect : ColorRect = $ColorRect

# 切换场景
@onready var animation_player : AnimationPlayer = $ColorRect/AnimationPlayer

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


func change_scene(scene_path : String):
	animation_player.play("change_scene")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(scene_path)
	animation_player.play_backwards("change_scene")
