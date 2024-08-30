extends Control

@onready var statusLabel: Label = $VBoxContainer/MarginContainer/Label3
@onready var progressBar: ProgressBar = $VBoxContainer/ProgressBar

func _ready():
	statusLabel.text = "正在加载资源"
	_get_chart_list()
	progressBar.value = 50
	statusLabel.text = "正在加载配置"
	_get_user_config()
	progressBar.value = 100
	statusLabel.text = "准备就绪。欢迎！"
	await get_tree().create_timer(1.0).timeout
	SceneChanger.change_scene("res://Scenes/Visual/hub_scene.tscn")

# 读曲包
func _get_chart_list() -> void:
	
	var dir: DirAccess = DirAccess.open(Constant.ROOT_PATH)
	var pack_list: Dictionary = { }

	if dir:
		# 获取曲包
		dir.list_dir_begin()
		var dirName: String = dir.get_next()
		while dirName != "": 
			if dir.current_is_dir(): # 是否为文件夹？
				var mscList: Array[String] = []
				
				# 获取曲包内歌曲列表
				var packDir: DirAccess = DirAccess.open(Constant.ROOT_PATH + "/" + dirName)
				
				packDir.list_dir_begin()
				
				var mscName: String = packDir.get_next()
				
				while mscName != "":
					if packDir.current_is_dir():
						mscList.append(mscName)
					mscName = packDir.get_next()
				
				pack_list.merge(
					{ dirName: mscList }
				)
				
			dirName = dir.get_next()
	
	RunningData.pack_list = pack_list

# 读配置
func _get_user_config() -> void:
	var cfgFile: String = FileAccess.get_file_as_string("user://config.json")
	# 判空
	if cfgFile != "":
		var config: Dictionary = JSON.parse_string(cfgFile)
		RunningData.volume = config.volume
		RunningData.bglight = config.bglight
		RunningData.speed = config.speed
		RunningData.user_name = config["user_name"]
