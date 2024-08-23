extends Control


@onready var progress_bar : ProgressBar = $VBoxContainer/ProgressBar

@onready var state_label : Label = $VBoxContainer/Bottom/StateLabel

var msc_list : Array[String] = [ ]

var dir : DirAccess

var dir_name : String

func _ready():
	# 开始时关闭游戏的暂停状态
	get_tree().paused = false
	
	dir = DirAccess.open(GlobalScene.root_msc_path)
	
	progress_bar.value = 0
	state_label.text = "正在加载 ..."
	await get_tree().create_timer(0.5).timeout
	
	if dir:
		dir.list_dir_begin()
		dir_name = dir.get_next()
		while dir_name != "":
			msc_list.append(dir_name)
			dir_name = dir.get_next()
	print("内置歌单: ", msc_list)
	print("自定义歌单: ", GlobalScene.individual_msc_list)
	GlobalScene.msc_list = msc_list
	
	state_label.text = "准备就绪. 欢迎!"
	progress_bar.value = 100
	await get_tree().create_timer(0.5).timeout
	
	SceneChanger.change_scene("res://Scene/VisualScene/hub_scene.tscn")
	print("进入 hub_scene")
