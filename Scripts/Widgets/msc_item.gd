extends Control

var packName: String
var mscName: String
# var artists: String
var cover: Texture
var path: String

var nameLabel: Label
var arLabel: Label
var coverView: TextureRect
var root: ColorRect
var audioPlayer: AudioStreamPlayer

# TODO: 自动调整大小以适应不同屏幕
func set_up(
	packName: String, 				# 曲包名
	mscName: String, 				# 歌曲名
	nameLabel: Label, 				# 歌曲名称标签, 嵌套一层 packed_item 引用 select_scene 的 info 中展示的歌曲名称
	arLabel: Label, 				# 歌曲作者标签, 嵌套一层 packed_item 引用 select_scene 的 info 中展示的歌曲作者
	coverView: TextureRect, 		# 歌曲封面, 嵌套一层 packed_item 引用 select_scene 的 info 中展示的歌曲封面
	root: ColorRect,				# 嵌套一层 packed_item 引用 sele_scene 的 info 节点
	audioPlayer: AudioStreamPlayer	# 嵌套一层 packed_item 引用 sele_scene 的 AudioStreamPlayer 用于预览音乐
	) -> void:

	path = RunningData.rootMscPath + "/" + packName + "/" + mscName + "/"
	
	self.mscName = mscName
	self.packName = packName
	# self.artists = FileAccess.get_file_as_string(path + "info.txt")
	
	# self.cover = load(path + "cover.png")
	self.cover = ImageTexture.create_from_image(
		Image.load_from_file(
			path + "cover.png"
		)
	)
	
	self.nameLabel = nameLabel
	self.arLabel = arLabel
	self.coverView = coverView
	self.root = root
	self.audioPlayer = audioPlayer

	$MarginContainer/VBoxContainer/MscNameLabel.text = mscName 
	# $MarginContainer/VBoxContainer/ArLabel.text = artists
	$MarginContainer/TextureRect.texture = cover


func _on_button_pressed():
	# 在这个地方就已经开始解析谱面开头部分
	RunningData.json_path =  ProjectSettings.globalize_path(path + mscName + ".json")
	if !FileAccess.file_exists(RunningData.json_path):
		print("文件 <" + RunningData.json_path + "> 不存在")
		return
	RunningData.json_file_data = FileAccess.get_file_as_string(RunningData.json_path)
	RunningData.parsed_json = JSON.parse_string(RunningData.json_file_data)
	
	nameLabel.text = mscName
	arLabel.text = RunningData.parsed_json.General.Artist
	coverView.texture = cover
	
	RunningData.selected_msc_cover = self.cover
	
	# audioPlayer.stream = load(path + "audio.mp3")
	var audio_path = path + "audio.mp3"
	var audio_file = FileAccess.open(audio_path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = audio_file.get_buffer(audio_file.get_length())
	audioPlayer.stream = sound
	RunningData.audio_stream = sound
	
	audioPlayer.play()
	root.visible = true
