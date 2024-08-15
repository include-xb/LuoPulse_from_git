extends VBoxContainer

var grid: GridContainer

func _ready():
	$GridContainer.visible = false


func set_up(
	packName: StringName, 
	mscList: Array[String], 
	nameLabel: Label, 
	arLabel: Label, 
	coverView: TextureRect, 
	root: ColorRect,
	audioPlayer: AudioStreamPlayer
	) -> void:

	grid = $GridContainer
	
	$PanelContainer/PackPic/MarginContainer/PackNameLabel.text = packName
	
	# $PanelContainer/PackPic.texture = load(RunningData.rootMscPath + "/" + packName + "/" + "cover.jpg")
	
	$PanelContainer/PackPic.texture = ImageTexture.create_from_image(
		Image.load_from_file(
			RunningData.rootMscPath + "/" + packName + "/" + "cover.jpg"
		)
	)
	# 加载失败就使用默认图像
	if $PanelContainer/PackPic.texture == null:
		$PanelContainer/PackPic.texture = load("res://Assets/Images/hub_bg.jpg")
	
	for i in mscList:
		var item: Node = preload("res://Scenes/Widgets/msc_item.tscn").instantiate()
		item.set_up(packName, i, nameLabel, arLabel, coverView, root, audioPlayer)
		grid.add_child(item)


func _on_button_pressed():
	#if grid.visible == false:
	#	grid.visible = true
	#else :
	#	grid.visible = false
	grid.visible = !grid.visible
