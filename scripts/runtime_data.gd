extends Node

# 选中的音频流
var selected_audio_stream: AudioStreamMP3 = null

# 每分钟拍数 (从音频获取)
var bpm: float = 80

# 每秒拍数
var bps: float = bpm / 60

# 每拍秒数
var spb: float = 60 / bpm

# 速度 (可调)
var speed: float = 300

# 0 准线的 y 坐标
var decision_y: float = 520

# 当前每拍划分份数 4 / 8 / 16 / 32
var separate_num: int = 8

# 相邻两线之间的距离 px
var line_distance: float = spb / separate_num * speed
