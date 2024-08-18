extends VBoxContainer

var grid: GridContainer

func _ready():
	$GridContainer.visible = false


func set_up(
	packName: String,				# 曲包名称
	mscList: Array[String], 		# 曲包中的歌曲列表
	nameLabel: Label,				# 歌曲名称标签, 引用 select_scene 的 info 中展示的歌曲名称
	arLabel: Label,					# 歌曲作者信息, 引用 select_scene 的 info 中展示的作者信息
	coverView: TextureRect,			# 歌曲封面, 引用 sele_scene 的 info 中展示的封面
	root: ColorRect,				# 引用 sele_scene 的 info 节点
	audioPlayer: AudioStreamPlayer	# 引用 sele_scene 的 AudioStreamPlayer 用于预览音乐
	) -> void:
	
	grid = $GridContainer
	
	$PanelContainer/PackPic/MarginContainer/PackNameLabel.text = packName
	
	# INFO: Godot 是无法直接加载未导入的外部资源的
	# $PanelContainer/PackPic.texture = load(RunningData.rootMscPath + "/" + packName + "/" + "cover.jpg")
	
	$PanelContainer/PackPic.texture = load(
			RunningData.rootMscPath + "/" + packName + "/" + "cover.jpg")
	# 加载失败就使用默认图像
	if $PanelContainer/PackPic.texture == null:
		$PanelContainer/PackPic.texture = load("res://Assets/Images/hub_bg.jpg")
	
	# 遍历曲包歌单加载单曲
	for i in mscList:
		var item: Node = preload("res://Scenes/Widgets/msc_item.tscn").instantiate()
		item.set_up(
			packName, 
			i, 
			nameLabel, 
			arLabel, 
			coverView, 
			root, 
			audioPlayer
		)
		grid.add_child(item)


func _on_button_pressed():
	#if grid.visible == false:
	#	grid.visible = true
	#else :
	#	grid.visible = false
	grid.visible = !grid.visible
