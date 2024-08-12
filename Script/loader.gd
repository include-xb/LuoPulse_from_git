extends Node2D

class_name Loader

"""
scene.note				当前音符信息
scene.instance			当前音符实例
scene.notes				PlayScene 中放置音符的节点
scene.loaded_note_num	已加载的音符数
"""

# INFO: 既然用了标签那铺面为啥不用xml格式呢

var first = null

var data : String = ""

var track : int = -1

var beat : float = -1

# 暂时弃用
func load_note(scene : PlayScene, file : FileAccess) -> void:
	data = file.get_line()
	
	# INFO: 这里把一堆if换成了match，代码看起来会更紧凑
	match data:
		"<bpm>":
			# 获取bpm
			data = file.get_line()
			GlobalScene.bpm = float(data)
			return
		"<bpp>":
			# 获取每小节有几拍
			data = file.get_line()
			GlobalScene.bpp = int(data)
			return
		"<dt>":
			# 获取开头延时
			data = file.get_line()
			GlobalScene.dt = float(data)
			return
		"<del>":
			data = file.get_line()
			GlobalScene.dt = float(data)
			return
		"<tal>":
			# 获取音符总数
			data = file.get_line()
			scene.total_note_num = int(data)
			return
		"<p>":
			# 获取小节数
			data = file.get_line()
			GlobalScene.phara = int(data) - 1
			return

	# 结束读取
	if data == "<EOF>" or scene.file.get_position() == scene.file.get_length():
		file.close()
		scene.get_tree().paused = false
		
		# 开始让音符下落
		GlobalScene.is_running_note = true
		
		# 结束加载
		scene.is_loading_note = false
		
		# 加载画面结束
		scene.loading_panel.visible = false
		return
	
	scene.note = data.split(":")
	if not (scene.note[0] in "1234"):
		return
	
	# 加载音符
	scene.instance = scene.single_note.instantiate()
	scene.notes.add_child(scene.instance)
	
	# 已加载的音符数加 1
	scene.loaded_note_num += 1
	
	# 计算音符坐标
	scene.instance.position.x = 100 * float(scene.note[0]) - 250
	scene.instance.position.y = GlobalScene.sec_to_length(float(scene.note[1]) + GlobalScene.bpp * GlobalScene.phara )
	
	if first == null:
		first = scene.instance
		first.name = "FIRST"

# 新的加载函数
func load_note_in_once(scene : PlayScene, res_str : PackedStringArray) -> void:
	
	if data == "<EOF>" or scene.index == res_str.size() - 1:
		scene.get_tree().paused = false
		GlobalScene.is_running_note = true
		scene.is_loading_note = false
		scene.loading_panel.visible = false
		return
	
	data = res_str[scene.index]
	
	if data == "":
		scene.index += 1
		# print("检测到空行")
		return
	
	if data[0] == "-":
		scene.index += 1
		# print("检测到注释")
		return
	
	if data[-1] == '\r':
		data = data.trim_suffix('\r')
	
	match data:
		"<bpm>":
			scene.index += 1
			data = res_str[scene.index]
			GlobalScene.bpm = float(data)
			print("bpm: ", GlobalScene.bpm)
			scene.index += 1
			return
		"<bpp>":
			scene.index += 1
			data = res_str[scene.index]
			GlobalScene.bpp = int(data)
			print("bpp: ", GlobalScene.bpp)
			scene.index += 1
			return
		"<dt>":
			scene.index += 1
			data = res_str[scene.index]
			GlobalScene.dt = float(data)
			print("dt: ", GlobalScene.dt)
			scene.index += 1
			return
		"<del>":
			scene.index += 1
			data = res_str[scene.index]
			GlobalScene.del = float(data)
			print("del: ", GlobalScene.del)
			scene.index += 1
			return
		"<tal>":
			scene.index += 1
			data = res_str[scene.index]
			scene.total_note_num = int(data)
			print("total: ", scene.total_note_num)
			scene.index += 1
			return
		"<p>":
			scene.index += 1
			data = res_str[scene.index]
			GlobalScene.phara = int(data) - 1
			scene.index += 1
			return

	scene.note = data.split(":")
	if not (scene.note[0] in "1234"):
		# print("被截断的字符: ", scene.note[0])
		scene.index += 1
		return
	
	track = int(scene.note[0])
	beat = float(scene.note[1]) + GlobalScene.bpp * GlobalScene.phara
	
	scene.instance = scene.single_note.instantiate()
	scene.notes.add_child(scene.instance)
	
	# 计算音符坐标
	scene.instance.position.x = 100 * track - 250
	scene.instance.position.y = GlobalScene.beat_to_length(beat)
	
	scene.instance.id = scene.loaded_note_num
	scene.instance.appeal_time = beat * 60 / GlobalScene.bpm + GlobalScene.saved_adjustment
	
	# 已加载的音符数加 1
	scene.loaded_note_num += 1
	# 谱面缓存的下标后移 1
	scene.index += 1
	
	if first == null:
		first = scene.instance
		first.name = "FIRST"
		print(first)
	
	return
