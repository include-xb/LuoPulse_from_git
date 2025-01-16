extends Control

@onready var user_name_label : Label = $Header/HBoxContainer/UserInfo/Label

@onready var version_label : Label = $Header/HBoxContainer/GameInfo/HBoxContainer/Version

@onready var user_img : TextureRect = $Header/HBoxContainer/UserInfo/TextureRect


# INFO 
# 由于 B 站使用 .avif 格式图像, Godot 无法实时获取 P 主头像
# 但是通过修改文件路径(动用一些不正当方法): 
# 原链接: https://XXX.XXX/XXX/XXX.jpg@XXXX.avif
# 修改后: https://XXX.XXX/XXX/XXX.jpg

# 彩蛋在此!!!
"""
var producer_img : Dictionary = {
	"ilem" : preload("res://Resource/Img/producer_img/ilem.jpg"),
	"COPY": preload("res://Resource/Img/producer_img/COP.jpg"),
	"阿良良木健": preload("res://Resource/Img/producer_img/allmj.jpg"),
	"雨狸": preload("res://Resource/Img/producer_img/yl.jpg"),
	"纯白": preload("res://Resource/Img/producer_img/cb.jpg"),
	"litterzy": preload("res://Resource/Img/producer_img/litterzy.jpg"),
	"JUSF周存": preload("res://Resource/Img/producer_img/zc.jpg")
}
"""

var producer_img_link : Dictionary = {
	"ilem" : "https://i1.hdslb.com/bfs/face/2e25812e0ba75174c07fe9b61e68e20c66e89499.jpg",
	"COPY": "https://i2.hdslb.com/bfs/face/544541afa73735172abbe9e6a4bd44100899d48d.jpg",
	"阿良良木健": "https://i0.hdslb.com/bfs/face/bf1d216ba00c86e95bbe4502bd0d2190a39b8121.jpg",
	"雨狸": "https://i1.hdslb.com/bfs/face/9acdc0d6c81f6f03d3830d6937efe831f9923400.jpg",
	"纯白": "https://i0.hdslb.com/bfs/face/06fa2af2e14b9e1b417792c9d5253766240510e1.jpg",
	"litterzy": "https://i1.hdslb.com/bfs/face/a9d5957e39815c03f4bf859fc8a28d3e9abdb895.jpg",
	"JUSF周存": "https://i1.hdslb.com/bfs/face/f8be673ab57ac98085fafb2bc36d03d59a94bd36.jpg"
}


func  _ready():
	#if producer_img.has(GlobalScene.user_name):
		#print("检测到P主名")
		# GlobalScene.user_img = producer_img[GlobalScene.user_name]
	#else:
		#GlobalScene.user_img = preload("res://Resource/Img/user.jpeg")
	# user_img.texture = GlobalScene.user_img
	
	
	if producer_img_link.has(GlobalScene.user_name):
		var http_request = HTTPRequest.new()
		add_child(http_request)
		http_request.connect("request_completed", _on_image_request_completed)
		http_request.request(producer_img_link[GlobalScene.user_name])
	
	user_name_label.text = GlobalScene.user_name
	version_label.text = GlobalScene.version
	
	user_name_label.max_lines_visible = GlobalScene.max_user_name_length
	user_name_label.visible_characters = GlobalScene.max_user_name_length


@warning_ignore("unused_parameter")
func _on_image_request_completed(result, response_code, headers, body : PackedByteArray):
	if response_code == 200:
		var image = Image.new()
		if image.load_jpg_from_buffer(body) == OK:
			var texture = ImageTexture.create_from_image(image)
			
			GlobalScene.user_img = texture
			user_img.texture = GlobalScene.user_img
			# print(user_img.texture == null)
			
		else:
			print("图像加载失败")
	else:
		print("图像请求失败")


func _on_start_button_pressed():
	SceneChanger.change_scene("res://Scene/VisualScene/package_scene.tscn")
	print("进入 package_scene")


func _on_setting_button_pressed():
	SceneChanger.change_scene("res://Scene/VisualScene/setting_scene.tscn")
	print("进入 setting_scene")


func _on_quit_button_pressed():
	get_tree().quit()


# 新建谱面按钮
func _on_new_button_pressed():
	SceneChanger.change_scene("res://Scene/VisualScene/chart_editor_scene.tscn")
