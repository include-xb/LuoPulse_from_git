extends Panel


# INFO: 点击 MainBody 节点, 测试时可在检查器中可修改 BPM Speed SeparateNum
# INFO: 暂时通过 上下键 控制移动
# INFO: 场景中的一个音符用于参照移动
# TODO: 解析音频文件的 bpm
# TODO: 吸附节拍线
# TODO: 鼠标滚轮移动
# TODO: 写入谱面
# TODO: 谱面播放
# ...


@onready var basebeatline: PackedScene = load("res://scenes/BeatLine/basebeatline.tscn")

@onready var minbeatline: PackedScene = load("res://scenes/BeatLine/minbeatline.tscn")

@onready var minbeatline_od: PackedScene = load("res://scenes/BeatLine/minbeatline_od.tscn")

@onready var audio_player: AudioStreamPlayer = $"../AudioStreamPlayer"

@onready var canvas: Control = $Tracks

@onready var lines: Control = $Tracks/beatline

@onready var decision_line: HSeparator = $ColorRect/Separators/dec


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

# 正在演示
var is_playing: bool = false

var current_y: float = 0.0

var window_height: float = 648.0

var free_buffer_height: float = 100.0


"""

|___________|___________|___________|___________|
| 376 ~ 476 | 476 ~ 576 | 576 ~ 676 | 676 ~ 776 |

"""


func _ready() -> void:
	separate_num = 2 ** (exprot_separate_num + 2)
	line_distance = spb / separate_num * speed
	
	RuntimeData.separate_num = separate_num
	RuntimeData.line_distance = line_distance
	
	# 从 current_y 处开始绘制节拍线
	current_y = 520 - window_height + 1 # 1 为偏移量
	RuntimeData.beatline_positions.append(current_y)
	
	canvas.position.y += line_distance * (2 ** (exprot_separate_num + 2))
	#set_line(2)


func _process(delta: float) -> void:
	var canvas_top_y: float = canvas.position.y
	var canvas_bottom_y: float = canvas.position.y + window_height
	var canvas_decision_line_y: float = canvas.position.y + decision_y
	
	if is_playing:
		canvas.global_position.y += speed * delta
	
	if Input.is_key_pressed(KEY_UP):
		canvas.position.y += speed * delta
	if Input.is_key_pressed(KEY_DOWN):
		canvas.position.y -= speed * delta
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN):
		canvas.position.y -= speed * delta
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP):
		canvas.position.y += speed * delta
	#if Input.is_action_pressed("wheel_up"):
		#canvas.position.y += speed * delta
	#if Input.is_action_pressed("wheel_down"):
		#canvas.position.y -= speed * delta
	
	if Input.is_key_pressed(KEY_SPACE):
		is_playing = !is_playing
		if audio_player.stream != null:
			audio_player.stream_paused = !audio_player.stream_paused
	
	# 如果向上滚动到边界就再向上放置一节拍的节拍线
	if -current_y <= canvas.position.y + window_height:
		print("delta_y: ", canvas.position.y - current_y)
		set_line(1)
	

# 从下向上放置
func set_line(beat: int) -> void:
	# 一拍
	for b in range(beat):
		var instance_base: HSeparator = basebeatline.instantiate()
		instance_base.position.y = current_y
		lines.add_child(instance_base)
		
		# 每拍内分
		for div in range(separate_num - 1):
			current_y -= line_distance
			# RuntimeData.beatline_positions.append(current_y)
			var instance: HSeparator = minbeatline.instantiate() if div % 2 == 0 else minbeatline_od.instantiate()
			instance.position.y = current_y
			lines.add_child(instance)
			RuntimeData.beatline_positions.append(current_y)
		
		current_y -= line_distance
		RuntimeData.beatline_positions.append(current_y)


func _on_tap_pressed() -> void:
	print("切换状态, 当前状态: Tap (from main_body.gd)")
	RuntimeData.current_status = RuntimeData.STATUS.TAP


func _on_drug_pressed() -> void:
	print("切换状态, 当前状态: Drug (from main_body.gd)")
	RuntimeData.current_status = RuntimeData.STATUS.DRUG


func _on_heart_pressed() -> void:
	print("切换状态, 当前状态: Heart (from main_body.gd)")
	RuntimeData.current_status = RuntimeData.STATUS.HEART



func _on_release_pressed() -> void:
	print("切换状态, 当前状态: Release (from main_body.gd)")
	RuntimeData.current_status = RuntimeData.STATUS.RELEASE


func _on_eraser_pressed() -> void:
	print("切换状态, 当前状态: Eraser (from main_body.gd)")
	RuntimeData.current_status = RuntimeData.STATUS.ERASE


func _on_poniter_pressed() -> void:
	print("切换状态, 当前状态: Pointer (from main_body.gd)")
	RuntimeData.current_status = RuntimeData.STATUS.POINTER


# 导出
func _on_export_pressed() -> void:
	pass # Replace with function body.
