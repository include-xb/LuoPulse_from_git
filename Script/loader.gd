extends Node2D

class_name Loader

"""
scene.note				当前音符信息
scene.instance			当前音符实例
scene.notes				PlayScene 中放置音符的节点
scene.loaded_note_num	已加载的音符数
"""

var data : String = ""

# return 相当于 continue
func load_note(scene : PlayScene, file : FileAccess) -> void:
	data = file.get_line()
	
	# 获取bpm
	if data == "<bpm>":
		data = file.get_line()
		GlobalScene.bpm = float(data)
		return

	# 获取每小节有几拍
	if data == "<bpp>":
		data = file.get_line()
		GlobalScene.bpp = int(data)
		return

	# 获取开头延时
	if data == "<dt>":
		data = file.get_line()
		GlobalScene.dt = float(data)
		return
	
	if data == "<del>":
		data = file.get_line()
		GlobalScene.del = float(data)
		return
	
	# 获取音符总数
	if data == "<tal>":
		data = file.get_line()
		scene.total_note_num = int(data)
		return
	
	# 获取小节数
	if data == "<p>" or data == "<P>":
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
	
	return


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
	
	# print("\n\n第", scene.index, "行是: ", data)
	
	if data == "<bpm>":
		scene.index += 1
		data = res_str[scene.index]
		GlobalScene.bpm = float(data)
		print("bpm: ", GlobalScene.bpm)
		scene.index += 1
		return
	
	if data == "<bpp>":
		scene.index += 1
		data = res_str[scene.index]
		GlobalScene.bpp = int(data)
		print("bpp: ", GlobalScene.bpp)
		scene.index += 1
		return
	
	if data == "<dt>":
		scene.index += 1
		data = res_str[scene.index]
		GlobalScene.dt = float(data)
		print("dt: ", GlobalScene.dt)
		scene.index += 1
		return
	
	if data == "<del>":
		scene.index += 1
		data = res_str[scene.index]
		GlobalScene.del = float(data)
		print("del: ", GlobalScene.del)
		scene.index += 1
		return
	
	if data == "<tal>":
		scene.index += 1
		data = res_str[scene.index]
		scene.total_note_num = int(data)
		print("total: ", scene.total_note_num)
		scene.index += 1
		return
	
	if data == "<p>" or data == "<P>":
		scene.index += 1
		data = res_str[scene.index]
		GlobalScene.phara = int(data) - 1
		# print("当前phara: ", GlobalScene.phara)
		scene.index += 1
		return
	
	scene.note = data.split(":")
	if not (scene.note[0] in "1234"):
		print("被截断的字符: ", scene.note[0])
		scene.index += 1
		return
	
	# print("该字段通过条件, data=" + data + "; note: ", scene.note)
	
	scene.instance = scene.single_note.instantiate()
	scene.notes.add_child(scene.instance)
	
	# 已加载的音符数加 1
	scene.loaded_note_num += 1
	
	# 计算音符坐标
	scene.instance.position.x = 100 * float(scene.note[0]) - 250
	scene.instance.position.y = GlobalScene.sec_to_length(float(scene.note[1]) + GlobalScene.bpp * GlobalScene.phara )
	
	scene.index += 1
	return


func load_note_res_only(scene : PlayScene, res_str : PackedStringArray) -> Array:
	var res_arr : Array = [ ]
	
	for i in range(0, res_str.size()):
		var data : String = res_str[i]
		
		if data == "" or data[0] == '-':
			continue
		
		if data[-1] == '\r':
			data = data.trim_suffix('\r')
		
		if data == "<bpm>":
			i += 1
			data = res_str[i]
			GlobalScene.bpm = float(data)
			continue
		
		if data == "<bpp>":
			i += 1
			data = res_str[i]
			GlobalScene.bpp = int(data)
			continue
		
		if data == "<dt>":
			i += 1
			data = res_str[i]
			GlobalScene.dt = float(data)
			continue
		
		if data == "<del>":
			i += 1
			data = res_str[i]
			GlobalScene.del = float(data)
			continue
		
		if data == "<tal>":
			i += 1
			data = res_str[i]
			scene.total_note_num = int(data)
			continue
		
		if data == "<p>" or data == "<P>":
			i += 1
			data = res_str[i]
			GlobalScene.phara = int(data)
			continue
		
		var note : PackedStringArray = data.split(":")
		
		if not(note[0] in "1234"):
			continue
		
		if note.size() < 2:
			continue
		
		# print(note)
		res_arr.append(note[0] + ":" + str((GlobalScene.phara * GlobalScene.bpp + float(note[1])) * 60 / GlobalScene.bpm))
		scene.loaded_note_num += 1
		
	scene.get_tree().paused = false
	GlobalScene.is_running_note = true
	scene.is_loading_note = false
	scene.loading_panel.visible = false
	return res_arr


func load_note_from_res_piece(scene : PlayScene, res_piece : String) -> void:
	var note : PackedStringArray = res_piece.split(":")
	var track_num : int = int(note[0])
	var time : float = float(note[1])
	
	var instance : SINGLE_NOTE = scene.single_note.instantiate()
	scene.notes.add_child(instance)
	
	# 计算音符坐标
	instance.position.x = 100 * track_num - 250
	# instance.position.y = 185 - 10 * Engine.get_frames_per_second() * time
	instance.posotion.y = 185 - 10 * Engine.get_frames_per_second() * time
