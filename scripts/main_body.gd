extends Panel


# CAUTION: 
# 	TO 流星酱 🌠✨⭐🎵🎶🎼:
# 		这是小白的遗言. 
# 		当你看到下面这些注释时, 小白已经再次处于无法触碰电脑的状态.
# 		离高考也就一年多了, 在此期间请星星酱以学习为主哦.
# 		高考完了之后一块出去van呀 q≧▽≦q)
#
# INFO: 1. 点击 MainBody 节点, 测试时可在检查器中可修改 BPM Speed SeparateNum(这个是每小节分割的份数)
# 		2. 上下键 或 侧边滚动条 控制移动 
# 			BUG: 如果滚动条在最底端, 那么它无法被拖动. 需要让它上来一点, 才能被拖动.
# 		3. 这个场景的 Select(node_path: "../Select") 是临时的. 拖入音频并且填入谱面名称就可以点击继续开始编辑.
#
# INFO: 这是四条轨道边界的 x 轴信息
# 		|___________|___________|___________|___________|
# 		| 376 ~ 476 | 476 ~ 576 | 576 ~ 676 | 676 ~ 776 |
#
#
# INFO: ↓↓↓ 下面这个 TODO 交给你啦 ✿◡‿◡)
# TODO: 1. 在创建项目时让用户填写音频的bpm, 存放在 RuntimeData.bpm 中
#		2. 在创建项目时让用户填写谱面的保存路径, 存放在 RuntimeData.save_path 中
# 		3. 额...好像有很多东西都要让用户填写, 它们在 RuntimeData.gd (line6 ~ line43)
#
# INFO: ↓↓↓ 下面的个交给以后的我吧, 如果你想来做做也非常欢迎 ヾ≧▽≦*)o
# TODO: 1. 鼠标滚轮移动
# 		2. 谱面播放, 滚动时存在打击音效
# 		3. 写入音频 封面 (视频)
#
# INFO: 
# 	general.json 的格式下面的代码有, 就是 general_data 这个字典
# 	下面是谱面正文格式, 独立出一个新文件, 以 <难度>.lp 命名, 用 json 格式记录
# 	例: EZ.lp:
# 	{
# 		"objects": [
# 			{
# 				"type": "",		← 这里有 "tap" "drag" "release" "heart" 四种
# 				"time": ...,	← 这里单位为毫秒, 类型是 int
# 				"column": ..	← ATTENTION: 轨道索引从 0 开始
# 			}, 
# 			...
# 		]
# 	}
# 


# 白线
@onready var basebeatline: PackedScene = load("res://scenes/BeatLine/basebeatline.tscn")

@onready var minbeatline: PackedScene = load("res://scenes/BeatLine/minbeatline.tscn")

@onready var minbeatline_od: PackedScene = load("res://scenes/BeatLine/minbeatline_od.tscn")

# 暂停图标
@onready var paused_icon: Texture2D = load("res://res/images/pause.svg")

# 开始图标
@onready var continue_icon: Texture2D = load("res://res/images/continue.png")

@onready var audio_player: AudioStreamPlayer = $"../AudioStreamPlayer"

# 移动这个节点就可以实现音符的滚动
@onready var canvas: Control = $Tracks

# 生成的节拍线会添加到这个节点下
@onready var lines: Control = $Tracks/beatline

# 判定线
@onready var decision_line: HSeparator = $ColorRect/Separators/dec

@onready var status_tip_label: Label = $ColorRect/Status

@onready var pause_tip: Label = $ColorRect/PauseTip

# 设置面板, 打算用来修改 speed, SeparateNum... 这个暂时没用
@onready var setting_panel: Panel = $Setting

# 滑动条
@onready var vslider: VSlider = $ColorRect/VSlider


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

# 当前最上方的一根节拍线的 y 坐标
var current_y: float = 0.0

# 各种状态
var status_arr: Array = [ "TAP 蓝键", "DRAG 黄键", "RELEASE 红键", "HEART 心跳键", "ERASE 橡皮", "POINTER 指针" ]

# 窗口高度
var window_height: float = 648.0

# general.json 中的内容
var general_data: Dictionary = {
	"meta": {
		"title": RuntimeData.title,
		"files": {
			"cover": RuntimeData.cover,
			"audio": RuntimeData.audio,
			"video": RuntimeData.video
		},
		"makers": {
			"vocal": RuntimeData.vocal,
			"lyrics": RuntimeData.lyrics,
			"compose": RuntimeData.compose,
			"arrange": RuntimeData.arrange,
			"adjust": RuntimeData.adjust,
			"mix": RuntimeData.mix,
			"pv": RuntimeData.pv,
			"illustrator": RuntimeData.illustrator,
			"creator": RuntimeData.creator
		}
	},
	"settings": {
		"color": {
			"note": {
				"tap":      [ 102, 204, 255, 0 ],
				"drug":     [ 0,   255, 255, 0 ],
				"release":  [ 255, 0,   0,   0 ],
				"heart":    [ 255, 50,  50,  0 ]
			},
			"track": {
				"left2":    [ 20,  20,  20, 190 ],
				"left1":    [ 20,  20,  20, 190 ],
				"right1":   [ 20,  20,  20, 190 ],
				"right2":   [ 20,  20,  20, 190 ]
			},
			"decisionline": [ 102, 204, 255, 0  ]
		}
	}
}

# 谱面正文(分出独立的一个文件) <难度>.lp 内容:
var note_data: Dictionary = {
	"objects": [
	]
}


func _ready() -> void:
	# 计算到每拍被划分的份数
	separate_num = 2 ** (exprot_separate_num + 2)
	# 计算相邻两线之间的距离
	line_distance = spb / separate_num * speed
	
	RuntimeData.separate_num = separate_num
	RuntimeData.line_distance = line_distance
	
	# 从 current_y 处开始绘制节拍线
	current_y = 520 - window_height + 1 # 1 为偏移量
	RuntimeData.beatline_positions.append(current_y)
	
	# 让制谱器一开始判定线停留的位置在 0 节拍处
	canvas.position.y += line_distance * (2 ** (exprot_separate_num + 2))
	
	# 设置当前状态为指针(就是什么都放不了)
	change_status(RuntimeData.STATUS.POINTER)

# 轨道上下滚动
func move(dire: String, delta: float) -> void:
	is_playing = false
	update_button_icon()
	if dire == "up":
		vslider.value += delta
	else:
		vslider.value -= delta


var t = true
func _process(delta: float) -> void:
	# 在开始时获得音频长度
	if t and audio_player.stream != null:
		vslider.max_value = audio_player.stream.get_length()
		t = false
	
	var canvas_top_y: float = canvas.position.y
	var canvas_bottom_y: float = canvas.position.y + window_height
	var canvas_decision_line_y: float = canvas.position.y + decision_y
	
	# 音符在自己滚动时
	if is_playing:
		canvas.global_position.y += speed * delta
		audio_player.stream_paused = false
		vslider.value = audio_player.get_playback_position()
		pause_tip.visible = false
	else:
		audio_player.stream_paused = true
		pause_tip.visible = true
	
	if Input.is_key_pressed(KEY_UP):
		move("up", delta)
	if Input.is_key_pressed(KEY_DOWN):
		move("down", delta)
	
	
	if Input.is_key_pressed(KEY_SPACE):
		_on_pause_pressed()
		#if audio_player.stream != null:
			#audio_player.stream_paused = !audio_player.stream_paused
	
	# 如果向上滚动到边界就再向上放置一节拍的节拍线
	if -current_y <= canvas.position.y + window_height:
		print("delta_y: ", canvas.position.y - current_y)
		set_line(1)
	

# 从下向上放置
func set_line(beat: int) -> void:
	# 一拍
	for i in range(beat):
		# 白线
		set_base_line()
		
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


func set_base_line() -> void:
	# 白色线
	var instance_base: HSeparator = basebeatline.instantiate()
	instance_base.position.y = current_y
	lines.add_child(instance_base)
	
	if RuntimeData.beat_index == 0:
		RuntimeData.start_line_global_position_y = instance_base.global_position.y
		print("start_line_global_position_y: ", RuntimeData.start_line_global_position_y)
	
	# 小节数
	var index_label: Label = Label.new()
	index_label.text = str(RuntimeData.beat_index)
	RuntimeData.beat_index += 1
	lines.add_child(index_label)
	index_label.position.x = instance_base.position.x - index_label.size.x
	index_label.position.y = instance_base.position.y - (index_label.size.y / 2)


func change_status(status: RuntimeData.STATUS) -> void:
	print("切换状态, 当前状态: ", status_arr[status] , " (from main_body.gd)")
	RuntimeData.current_status = status
	status_tip_label.text = status_arr[status]

# 更新暂停/开始按钮的图标
func update_button_icon() -> void:
	$ColorRect/Tools/MarginContainer/VBoxContainer/pause.icon = paused_icon if is_playing else continue_icon



func _on_tap_pressed() -> void:
	change_status(RuntimeData.STATUS.TAP)


func _on_drug_pressed() -> void:
	change_status(RuntimeData.STATUS.DRAG)


func _on_heart_pressed() -> void:
	change_status(RuntimeData.STATUS.HEART)


func _on_release_pressed() -> void:
	change_status(RuntimeData.STATUS.RELEASE)


func _on_eraser_pressed() -> void:
	change_status(RuntimeData.STATUS.ERASE)


func _on_poniter_pressed() -> void:
	change_status(RuntimeData.STATUS.POINTER)


# 设置 (暂时不做)
func _on_setting_pressed() -> void:
	return
	is_playing = false
	setting_panel.visible = true


# 导出
func _on_export_pressed() -> void:
	# 写入 general.json
	DirAccess.make_dir_recursive_absolute(RuntimeData.save_path)
	var general_file : FileAccess = FileAccess.open(RuntimeData.save_path + "general.json", FileAccess.WRITE)
	general_file.store_string(JSON.stringify(general_data))
	general_file.close()
	
	is_playing = false
	
	# 所有放置的音符
	var total_note_contain: Array = RuntimeData.contain.track0 + RuntimeData.contain.track1 + RuntimeData.contain.track2 + RuntimeData.contain.track3
	
	# 首先对列表中的所有音符排序, 按照从下到上顺序, 这样最终谱面中的音符就是按照时间排列
	for time in range(total_note_contain.size()):
		for i in range(total_note_contain.size()):
			for j in range(i + 1, total_note_contain.size()):
				if total_note_contain[i].global_position.y < total_note_contain[j].global_position.y:
					var temp = total_note_contain[j]
					total_note_contain[i] = total_note_contain[j]
					total_note_contain[j] = temp
	
	# 接下来遍历音符列表, 写入谱面
	for item in total_note_contain:
		var type = item.type
		var column = item.column
		var distance: float = RuntimeData.start_line_global_position_y - item.position.y - 10 + 1 # 10是音符高度, 1是偏移量
		var time: float = round(distance / RuntimeData.speed * 1000) # 单位为毫秒
		
		note_data.objects.append({
			"time": time,
			"type": type,
			"column": column
		})
	var note_file : FileAccess = FileAccess.open(RuntimeData.save_path + "chart.json", FileAccess.WRITE)
	note_file.store_string(JSON.stringify(note_data))
	note_file.close()


# 播放条内容
func _on_v_slider_value_changed(value: float) -> void:
	if is_playing:
		return
	audio_player.play(value)
	audio_player.stream_paused = true
	
	# 计算音符需要滚动的位置
	var distance: float = value * RuntimeData.speed
	canvas.position.y = line_distance * (2 ** (exprot_separate_num + 2)) + distance


# 播放结束就停止滚动
func _on_audio_stream_player_finished() -> void:
	is_playing = false


# 暂停/开始
func _on_pause_pressed() -> void:
	is_playing = !is_playing
	update_button_icon()
