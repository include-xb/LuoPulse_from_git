extends Node

var pack_list: Dictionary

# 选中曲包名
var selected_pack_name: String

# 用户名
var user_name: String = "游客"
var temp_user_name: String

# 选中歌曲信息
var selected_msc: Dictionary

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

# 连击数
var cambo: int = 0

# 评级
var rating: String = ""

# 分数
var score: float

# 单个音符分数
var single_note_score: float

# setting:

var is_auto_play : bool = false

# 音符流速, 玩家可调, 默认 10
var speed : int = 10

var volume : int = 0

var bglight : int = 0
