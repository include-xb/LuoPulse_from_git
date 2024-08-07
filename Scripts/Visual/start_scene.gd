extends Control

@onready var statusLabel: Label = $VBoxContainer/MarginContainer/Label3
@onready var progressBar: ProgressBar = $VBoxContainer/ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	
	statusLabel.text = "正在加载资源"
	_get_chart_list()
	progressBar.value = 100
	statusLabel.text = "准备就绪。欢迎！"
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Scenes/Visual/hub_scene.tscn")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _get_chart_list() -> void:
	
	var dir: DirAccess = DirAccess.open("user://MscList")
	var chartList: Array = []
	# 是否存在msclist，如不存在则创建
	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		while file_name != "": 
			if dir.current_is_dir(): # 是否为文件夹？
				chartList.append(file_name)
			file_name = dir.get_next()
	else :
		DirAccess.make_dir_absolute("user://MscList")
	RunningData.chartList = chartList
