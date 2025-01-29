extends Control

@onready var audio_player: AudioStreamPlayer = $Window/AudioStreamPlayer
@onready var msc_path: LineEdit = $Window/NewProject/VBoxContainer2/VBoxContainer/MarginContainer/VBoxContainer/AudioPosition/HBoxContainer/LineEdit


func _ready() -> void:
	var window: Window = get_window()
	window.size = Vector2i(800, 950)
	window.borderless = false
	window.move_to_center()
	
	$MarginContainer/VBoxContainer/Title/VBoxContainer/Version.text = Constants.VERSION_NAME
	$Window.size = Vector2i(1440, 950)
	
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
	audio_player.play()
	
	msc_path.text = audio_path


func load_mp3(path: String) -> AudioStreamMP3:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var sound: AudioStreamMP3 = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	return sound






func _on_create_button_pressed() -> void:
	$Window.popup_centered()


func _on_window_close_requested() -> void:
	$Window.hide()
