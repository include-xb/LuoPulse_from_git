extends Control

@onready var audio_player: AudioStreamPlayer = $"../AudioStreamPlayer"
@onready var msc_path: LineEdit = $VBoxContainer2/VBoxContainer/MarginContainer/VBoxContainer/AudioPosition/HBoxContainer/LineEdit

func _ready() -> void:
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
