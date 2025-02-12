extends Node

# 选中的音频流
var selected_audio_stream: AudioStreamMP3 = null

var cover: String = "---.jpg"

var audio: String = "---.ogg"

var video: String = "---.ogv"

# 谱面保存路径
var save_path: String = "D://packedmsc/"

# 标题
var title: String = "-"

# 演唱
var vocal: String = "洛天依" # 也会有其他演唱

# 作词
var lyrics: String = "-"

# 作曲
var compose: String = "-"

# 编曲
var arrange : String = "-"

# 调校
var adjust: String = "-"

# 混音
var mix: String = "-"

# pv
var pv: String = "-"

# 曲绘
var illustrator: String = "-"

# 制谱
var creator: String = "-"


# 每分钟拍数 (从音频获取)
var bpm: float = 80

# 每秒拍数
var bps: float = bpm / 60

# 每拍秒数
var spb: float = 60 / bpm

# 速度 (可调)???
var speed: float = 700

# 0 准线的 y 坐标
var decision_y: float = 520

# 当前每拍划分份数 4 / 8 / 16 / 32
var separate_num: int = 8

# 相邻两线之间的距离 px
var line_distance: float = spb / separate_num * speed

enum STATUS { 
	TAP,
	DRAG = 1,
	RELEASE,
	HEART,
	ERASE,
	POINTER
}

# 当前状态
var current_status: int = STATUS.POINTER

var contain: Dictionary = {
	"track0": [],
	"track1": [],
	"track2": [],
	"track3": [],
}

var can_put_note: bool = true

# 存放节拍线的y坐标, 用于坐标吸附
var beatline_positions: Array = []

# 当前最大小节的序号, 从1开始计数
var beat_index: int = -1

#var time_arr: Array = []
#
#var type_arr: Array = []
#
#var column_arr: Array = []


# 对应音频 0s 位置的节拍线的y坐标 
# ATTENTION: 制谱器在音频 0s 之前的位置也会生成一小节的线, 这段线因程序bug出现, 所以需要忽视
var start_line_global_position_y: float = 0.0
