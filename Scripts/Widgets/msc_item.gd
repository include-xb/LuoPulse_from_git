extends Control

var packName: String
var mscName: String
var artists: String
var cover: Texture2D
var path: String

var nameLabel: Label
var arLabel: Label
var coverView: TextureRect
var root: ColorRect
var audioPlayer: AudioStreamPlayer

# TODO: 自动调整大小以适应不同屏幕
func set_up(
	packName: String, 
	mscName: String, 
	nameLabel: Label, 
	arLabel: Label, 
	coverView: TextureRect, 
	root: ColorRect, 
	audioPlayer: AudioStreamPlayer
	) -> void:

	path = RunningData.rootMscPath + "/" + packName + "/" + mscName + "/"
	
	self.mscName = mscName
	self.packName = packName
	self.artists = FileAccess.get_file_as_string(path + "info.txt")
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
	$MarginContainer/VBoxContainer/ArLabel.text = artists
	$MarginContainer/TextureRect.texture = cover


func _on_button_pressed():
	nameLabel.text = mscName
	arLabel.text = artists
	coverView.texture = cover
	
	# audioPlayer.stream = load(path + "audio.mp3")
	var audio_path = path + "audio.mp3"
	var audio_file = FileAccess.open(audio_path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = audio_file.get_buffer(audio_file.get_length())
	audioPlayer.stream = sound
	
	audioPlayer.play()
	root.visible = true
