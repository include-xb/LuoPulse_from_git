extends Control

@onready var statusLabel: Label = $VBoxContainer/MarginContainer/Label3
@onready var progressBar: ProgressBar = $VBoxContainer/ProgressBar

func _ready():
	statusLabel.text = "正在加载资源"
	_get_chart_list()
	progressBar.value = 100
	statusLabel.text = "准备就绪。欢迎！"
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Scenes/Visual/hub_scene.tscn")

func _get_chart_list() -> void:
	
	var dir: DirAccess = DirAccess.open(RunningData.rootMscPath)
	var mscPackList: Dictionary = { }

	if dir:
		# 获取曲包
		dir.list_dir_begin()
		var dirName: String = dir.get_next()
		while dirName != "": 
			if dir.current_is_dir(): # 是否为文件夹？
				var mscList: Array[String] = []
				
				# 获取曲包内歌曲列表
				var packDir: DirAccess = DirAccess.open(RunningData.rootMscPath + "/" + dirName)
				
				packDir.list_dir_begin()
				
				var mscName: String = packDir.get_next()
				
				while mscName != "":
					if packDir.current_is_dir():
						mscList.append(mscName)
					mscName = packDir.get_next()
				
				mscPackList.merge(
					{ dirName: mscList }
				)
				
			dirName = dir.get_next()
	
	RunningData.mscPackList = mscPackList
