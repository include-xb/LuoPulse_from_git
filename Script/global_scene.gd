extends Node2D

# 全局变量

# 播放 UI 点击音效
@onready var click_audio_player = $UIClick

# 播放音符点击音效
@onready var hit_audio_player = $Hit


var selected_msc_cover = null

var selected_msc_title : String = ""

var default_msc_cover_path : String = "res://Resource/Img/17.png"

var default_adjustment : float = 0.0

var default_volume : int = 50

var default_msclist_path : String= "D:/MscList/"

var saved_adjustment : float = 0.0

var saved_volume :int = 50

var saved_msclist_path : String = "D:/MscList/"

var saved_difficulty : int = 1

var missing_count : int = 0

var perfect_count : int = 0

var good_count : int = 0

var score : int = 0

var bpm : int = 0

var bpp : int = 0

var dt : float = 0.0

var del : float = 0.0

var phara : int = 0

var is_running_note : bool = false


func _ready():
	click_audio_player.volume_db = linear_to_db(saved_volume * 0.02)
	hit_audio_player.volume_db = linear_to_db(saved_volume * 0.02)


func init() -> void:
	missing_count = 0
	perfect_count = 0
	good_count = 0
	selected_msc_title = ""


func set_volume(volume) -> void:
	saved_volume = volume
	_ready()


func play_click_audio() -> void:
	click_audio_player.play(0.0)


func play_hit_audio() -> void:
	hit_audio_player.play(0.0)

func change_scene_with_audio(scene: String) -> void:
	click_audio_player.play(0.0)
	get_tree().change_scene_to_file(scene)

# 将拍子计算为音符的 y 坐标
func sec_to_length(sec) -> float:
	return 185 - 10 * 60 * ((sec) * 60 / bpm + dt + saved_adjustment)
