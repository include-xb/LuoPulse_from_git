extends Control

@onready var status_label: Label = $"加载/状态"
@onready var progressbar: ProgressBar = $"加载/进度条"

func _ready() -> void:
	status_label.text = "正在加载资源..."
	get_package_list()
	progressbar.value = 75
	await get_tree().create_timer(0.5).timeout
	status_label.text = "正在加载配置..."
	get_user_config()
	progressbar.value = 100
	status_label.text = "准备就绪. 欢迎!"
	await get_tree().create_timer(0.5).timeout
	SceneChanger.change_scene("res://场景/主体场景/大厅.tscn")


"""
- 曲包:				<--- Constant.ROOT_RES_PATH, dir打开
	- 奇爱人生:			<--- dir_name, pack_dir打开
		- 春风来.lpz			<--- msc_name, zip_reader打开
		- 绝体绝命.lpz		<--- msc_name
	- (XXX专辑):			<--- dir_name
		- (XXX.lpz)			<--- msc_name

"""
# 读曲包
func get_package_list() -> void:
	var dir: DirAccess = DirAccess.open(Constants.ROOT_RES_PATH)
	var pack_list: Dictionary = { }
	var zip_reader: ZIPReader = ZIPReader.new()
	
	if !dir:
		print("读取曲包失败")
		return
	
	dir.list_dir_begin()
	var dir_name: String = dir.get_next()
	
	while dir_name != "":
		if !dir.current_is_dir():
			print("曲包为空")
			return
		
		# 读取曲包内的歌曲列表
		var msc_list: Array[String] = []
		var pack_dir: DirAccess = DirAccess.open(Constants.ROOT_RES_PATH + "/" + dir_name)
		
		if !pack_dir:
			print("读取曲包内单曲失败")
		
		pack_dir.list_dir_begin()
		var msc_name: String = pack_dir.get_next()
		while msc_name != "":
			if msc_name.ends_with(".lpz"):
				var current_zip_path: String = Constants.ROOT_RES_PATH + "/" + dir_name + "/" + msc_name
				var err = zip_reader.open(current_zip_path)
				if err != OK:
					print("读取文件 " + current_zip_path + " 失败")
					return
				msc_list.append(current_zip_path)
			msc_name = pack_dir.get_next()
		pack_list.merge(
			{ dir_name: msc_list } # 曲包名 对应 曲包内的歌曲列表
		)
		dir_name = dir.get_next()
	
	RuntimeData.pack_list = pack_list
	# 可通过 pack_list 获取歌曲路径

# 读配置
func get_user_config() -> void:
	var cfgFile: String = FileAccess.get_file_as_string("user://config.json")
	# 判空
	if cfgFile:
		var config: Dictionary = JSON.parse_string(cfgFile)
		RuntimeData.ui_volume = config.ui_volume
		RuntimeData.audio_volume = config.audio_volume
		RuntimeData.bglight = config.bglight
		RuntimeData.speed = config.speed
		RuntimeData.user_name = config["user_name"]
