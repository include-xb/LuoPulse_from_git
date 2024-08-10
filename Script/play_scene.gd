extends Node2D

class_name PlayScene

var loader : Loader = Loader.new()

@onready var notes : Node2D = $PlayPanel/Notes

@onready var loading_panel : Panel = $LoadingPanel

@onready var audio_stream_player : AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var menu_panle : Panel = $MenuPanel

@onready var cover : TextureRect = $TextureRect

@onready var start_audio_area : Area2D = $StartAudArea2D

@onready var missing_count_box : LineEdit = $VBoxContainer/MissingHBoxContainer/MissingCountLineEdit

@onready var perfect_count_box : LineEdit = $VBoxContainer/PerfectHBoxContainer/PerfectCountLineEdit

@onready var good_count_box : LineEdit = $VBoxContainer/GoodHBoxContainer/GoodCountLineEdit

@onready var menu_button : Button = $MenuButton

@onready var progressbar : ProgressBar = $LoadingPanel/ProgressBar

@onready var phara_count_box : LineEdit = $LoadingPanel/PharaLineEdit

@onready var num_count_box : LineEdit = $LoadingPanel/NumLineEdit

@onready var current_note_box : LineEdit = $LoadingPanel/CurrentNoteLineEdit

@onready var dialog_label : Label = $LoadingPanel/DialogLabel

@onready var dialog_timer : Timer = $LoadingPanel/DialogLabel/Timer

var notes_path : String = GlobalScene.saved_msclist_path + \
					 GlobalScene.selected_msc_title + "/" + \
					 GlobalScene.selected_msc_title + ".txt"

var file : FileAccess = FileAccess.open(notes_path, FileAccess.READ)

var note : PackedStringArray = []

# var is_first_note : bool = true

var first_note : bool = false

var total_duration : float = 0.0

var current_position : float = 0.0

var remaining_time : float = 0.0

signal finished

var is_running : bool = true

var is_loading_note : bool = true

var total_note_num : float = 1.0

var loaded_note_num : float = 0.0

var single_note : PackedScene = load("res://Scene/WidgetScene/single_note.tscn")

var instance : CharacterBody2D # = load("res://Scene/WidgetScene/single_note.tscn").instantiate()


func _ready():
	
	# 加载画面
	loading_panel.visible = true
	
	file = FileAccess.open(notes_path, FileAccess.READ)
	
	if file == null or !file.is_open():
		return
	
	# finished 信号连接
	finished.connect(display_finish_panel)
	
	# 外部加载歌曲
	var audio_path = GlobalScene.saved_msclist_path + GlobalScene.selected_msc_title + "/" + "audio.mp3"
	var audio_file = FileAccess.open(audio_path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = audio_file.get_buffer(audio_file.get_length())
	audio_stream_player.stream = sound
	
	# 获取音频的总时长（秒）
	total_duration = audio_stream_player.stream.get_length()
	
	# 开始时暂停菜单是隐藏状态
	menu_panle.visible = false
	
	# 判空则使用默认
	if GlobalScene.selected_msc_cover == null:
		GlobalScene.selected_msc_cover = preload("res://Resource/Img/17.png")
	
	# 加载背景图片 即歌曲封面
	cover.texture = GlobalScene.selected_msc_cover


@warning_ignore("unused_parameter")
func _process(delta):
	# 正在加载音符
	if is_loading_note:
		for i in range(100):
			loader.load_note(self, file)
		
	# 计算进度条进度
	progressbar.value = int(loaded_note_num / total_note_num * 100)
	
	# 如果是第一个音符被初始化时
	if first_note == false:
		first_note = true
		# 设置一个检测音符碰撞的碰撞箱, 如果第一个音符碰撞, 开始播放歌曲
		start_audio_area.position.y = 185 - 10 * GlobalScene.saved_difficulty * 60 * ( GlobalScene.dt + GlobalScene.saved_adjustment)
	
	# 如果按下 ESC
	if Input.is_key_pressed(KEY_ESCAPE):
		_on_menu_button_button_down()
	
	# 如果按下 SPACE
	if Input.is_key_pressed(KEY_SPACE):
		_on_resume_button_button_down()
	
	# 三个统计
	missing_count_box.text = str(GlobalScene.missing_count)
	perfect_count_box.text = str(GlobalScene.perfect_count)
	good_count_box.text = str(GlobalScene.good_count)
	
	# 获取当前歌曲播放位置
	current_position = audio_stream_player.get_playback_position()
	
	# 计算歌曲剩余时长
	remaining_time = total_duration - current_position

	# 如果剩余时长小于已读取到的最后减去时长
	if remaining_time <= GlobalScene.del and is_running:
		# 广播结束信号
		emit_signal("finished")
		is_running = false


func start_audio():
	audio_stream_player.play()
	audio_stream_player.volume_db = linear_to_db(GlobalScene.saved_volume * 0.01)


# 打开暂停菜单
func _on_menu_button_button_down():
	
	GlobalScene.play_click_audio()
	
	# 显示菜单
	menu_panle.visible = true
	
	# 暂停游戏
	get_tree().paused = menu_panle.visible
	
	# 打开暂停菜单的按钮需要随游戏暂停状态而切换可见性
	menu_button.visible = !get_tree().paused


# 继续游戏 在暂停菜单内
func _on_resume_button_button_down():
	
	GlobalScene.play_click_audio()
	
	# 隐藏暂停菜单
	menu_panle.visible = false
	
	# 继续游戏
	get_tree().paused = menu_panle.visible
	
	# 打开暂停菜单的按钮需要随游戏暂停状态而切换可见性
	menu_button.visible = !get_tree().paused


# 直接结束游戏
func _on_home_button_button_down():
	GlobalScene.play_click_audio()
	
	get_tree().paused = true
	emit_signal("finished")


# 打开谱面文件
func _on_view_button_button_down():
	GlobalScene.play_click_audio()
	OS.shell_open(notes_path)


# 开始播放音乐判定
func _on_start_aud_area_2d_body_entered(body : CharacterBody2D):
	if body.name == "FIRST":
		# 确保这部分代码只运行一次
		disconnect("body_entered", _on_start_aud_area_2d_body_entered)
		start_audio_area.queue_free()
		start_audio()


# 结束 展示结算画面
func display_finish_panel():
	var panel : PackedScene = preload("res://Scene/WidgetScene/finished_panel.tscn")
	var instance : Panel = panel.instantiate()
	add_child(instance)
