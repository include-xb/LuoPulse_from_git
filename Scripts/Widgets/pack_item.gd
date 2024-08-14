extends VBoxContainer

var grid: GridContainer

func set_up(
	packName: String, 
	mscList: Array[String], 
	nameLabel: Label, 
	arLabel: Label, 
	coverView: TextureRect, 
	root: ColorRect,
	audioPlayer: AudioStreamPlayer
	) -> void:

	grid = $GridContainer
	
	$PanelContainer/PackPic/MarginContainer/PackNameLabel.text = packName
	$PanelContainer/PackPic.texture = load(RunningData.rootMscPath + "/" + packName + "/" + "cover.jpg")
	
	for i in mscList:
		var item: Node = preload("res://Scenes/Widgets/msc_item.tscn").instantiate()
		item.set_up(packName, i, nameLabel, arLabel, coverView, root, audioPlayer)
		grid.add_child(item)



func _on_button_pressed():
	if grid.visible == false:
		grid.visible = true
	else :
		grid.visible = false
