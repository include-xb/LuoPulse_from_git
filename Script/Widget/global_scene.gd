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

# 
var json_path : String = ""

var json_string : String = ""

# 已解析的 json 数据
var parsed_json : Dictionary = {
	"General": {
		"Title": "test",
		"Artist": "-",
		"Creator": "-",
		"Version": "1.0",
		"BPM": 120
	},
	"HitObjects": [
		{
			"type": "tap",
			"time": 1,
			"column": 1
		},
		{
			"type": "hold",
			"time": 2.5,
			"column": 1,
			"duration": 1
		},
	]
}

# 标题
var selected_msc_title : String

# 封面
var selected_msc_cover : Texture

# 音频
var selected_stream : AudioStream

var auto_play : bool = true

# 开始 (进入 play_scene) 后的延迟
var delay_time : float = 2.0

# 音符流速
# 每一帧的位移为 speed * delta
# speed: pixel / second
# 若 speed= 600, fps = 60, 则 delta = 1/60 秒, 每一帧位移为 10 像素
var speed : float = 900

# 是否正在加载音符
var is_loading_note : bool = true

# 处于判定区间范围内的音符
var decision_area : Array = [ ]


func play_hit_audio():
	hit_audio_player.play()


func play_click_audio():
	click_audio_player.play()
