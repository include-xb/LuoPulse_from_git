extends VBoxContainer


# 歌单加载路径
var file_path : String = GlobalScene.saved_msclist_path + "MscList.txt"

var msc : PackedScene = preload("res://Scene/WidgetScene/demo_msc.tscn")

func _ready():
	
	# 根据路径打开歌单记录文件
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if file == null or !file.is_open():
		return
	
	while true:
		var data = file.get_line()
		if data == "":
			continue
		if data == "<EOF>" or file.get_position() == file.get_length():
			break
		print(file.get_position(), "/", file.get_length())
		print(data)
		
		# 根据读取到的信息实例化歌单内容
		var instance : DemoMsc = msc.instantiate()
		add_child(instance)
		
		# 设置歌单中歌曲标题
		instance.get_node("MscTitle").text = data
		instance.set_score()
	
	# 关闭文件
	file.close()
	
	# 在歌单最后添加分割线
	var separator = HSeparator.new()
	add_child(separator)
