extends Panel


# INFO: 点击 MainBody 节点, 测试时可在检查器中可修改 BPM Speed SeparateNum
# INFO: 暂时通过 上下键 控制移动
# INFO: 场景中的一个音符用于参照移动
# TODO: 解析音频文件的 bpm
# TODO: 鼠标滚轮移动
# TODO: 点击放置音符
# TODO: 不同音符 (状态机)
# TODO: 写入谱面
# TODO: 谱面播放
# ...


@onready var basebeatline: PackedScene = load("res://scenes/BeatLine/basebeatline.tscn")

@onready var minbeatline: PackedScene = load("res://scenes/BeatLine/minbeatline.tscn")

@onready var minbeatline_od: PackedScene = load("res://scenes/BeatLine/minbeatline_od.tscn")

@onready var canvas: ColorRect = $ColorRect

@onready var lines: Control = $Tracks/beatline


# 每分钟拍数 (从音频获取)
@export var bpm: float = 80

# 每秒拍数
var bps: float = bpm / 60

# 每拍秒数
var spb: float = 60 / bpm

# 速度 (可调)
@export var speed: float = 300

# 0 准线的 y 坐标
var decision_y: float = 520

# 当前每拍划分份数 4 / 8 / 16 / 32
@export_enum("4", "8", "16", "32") var exprot_separate_num: int = 2

var separate_num: int = 0

# 相邻两线之间的距离 px
var line_distance: float = 0.0


"""

|___________|___________|___________|___________|
| 376 ~ 476 | 476 ~ 576 | 576 ~ 676 | 676 ~ 776 |

"""
func _ready() -> void:
	separate_num = 2 ** (exprot_separate_num + 2)
	line_distance = spb / separate_num * speed
	
	RuntimeData.separate_num = separate_num
	RuntimeData.line_distance = line_distance
	
	var current_y: float = RuntimeData.decision_y
	# 每拍
	for beat in range(5):
		var instance_base: HSeparator = basebeatline.instantiate()
		instance_base.global_position.y = current_y
		lines.add_child(instance_base)
		
		# 每拍内分
		for div in range(separate_num - 1):
			current_y -= line_distance
			var instance: HSeparator = minbeatline.instantiate() if div % 2 == 0 else minbeatline_od.instantiate()
			instance.global_position.y = current_y
			lines.add_child(instance)
		
		current_y -= line_distance


func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_UP):
		canvas.position.y -= RuntimeData.speed * delta
	if Input.is_key_pressed(KEY_DOWN):
		canvas.position.y += RuntimeData.speed * delta
