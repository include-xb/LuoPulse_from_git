extends Control


@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var panel: PanelContainer = $Select/MarginContainer/VBoxContainer/Panel

@onready var path_line: LineEdit = $Select/MarginContainer/VBoxContainer/Path/MarginContainer/HBoxContainer/LineEdit

@onready var name_line: LineEdit = $Select/MarginContainer/VBoxContainer/Name/MarginContainer/HBoxContainer/LineEdit

@onready var select_panel: Control = $Select

@onready var tools: Control = $MainBody

@onready var setting_panel: Panel = $MainBody/Setting



func _ready() -> void:
	var window: Window = get_window()
	window.borderless = false
	window.size = Vector2i(1152, 648)
	
	select_panel.visible = true
	tools.visible = false
	setting_panel.visible = false
	
	get_viewport().files_dropped.connect(_on_files_dropped)


func _on_files_dropped(files_path_arr : Array):
	if files_path_arr.size() != 1:
		print("错误: 拖入文件数量不为1")
		return
	
	var file_path: String = files_path_arr[0]
	
	if !file_path.ends_with(".mp3"):
		print("错误: 拖入文件格式不为 .mp3")
		return
	
	var audio_path: String = file_path
	audio_player.stream = load_mp3(audio_path)
	audio_player.play(0)
	
	path_line.text = audio_path


func load_mp3(path: String) -> AudioStreamMP3:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var sound: AudioStreamMP3 = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	return sound


func _on_cancel_pressed() -> void:
	path_line.text = ""
	audio_player.stop()
	audio_player.stream = null


func _on_okay_pressed() -> void:
	if path_line.text == "" or name_line.text == "":
		return
	audio_player.stream_paused = true
	audio_player.seek(0)
	RuntimeData.selected_audio_stream = audio_player.stream
	select_panel.visible = false
	tools.visible = true
