extends Control

@onready var user_name_label : Label = $Header/HBoxContainer/UserInfo/Label

@onready var version_label : Label = $Header/HBoxContainer/GameInfo/HBoxContainer/Version

@onready var user_img : TextureRect = $Header/HBoxContainer/UserInfo/TextureRect


# INFO 
# 由于 B 站使用 .avif 格式图像, Godot 无法实时获取 P 主头像

# 彩蛋在此!!!
var producer_img : Dictionary = {
	"ilem" : preload("res://Resource/Img/producer_img/ilem.jpg"),
	"COPY": preload("res://Resource/Img/producer_img/COP.jpg"),
	"阿良良木健": preload("res://Resource/Img/producer_img/allmj.jpg"),
	"雨狸": preload("res://Resource/Img/producer_img/yl.jpg"),
	"纯白": preload("res://Resource/Img/producer_img/cb.jpg"),
	"litterzy": preload("res://Resource/Img/producer_img/litterzy.jpg"),
	"JUSF周存": preload("res://Resource/Img/producer_img/zc.jpg")
}

var producer_img_link : Dictionary = {
	"ilem" : "https://i1.hdslb.com/bfs/face/2e25812e0ba75174c07fe9b61e68e20c66e89499.jpg@240w_240h_1c_1s_!web-avatar-space-header.avif",
	"COPY": "https://i2.hdslb.com/bfs/face/544541afa73735172abbe9e6a4bd44100899d48d.jpg@240w_240h_1c_1s_!web-avatar-space-header.avif",
	"阿良良木健": "https://i0.hdslb.com/bfs/face/da441327b01b8ca98b97496f0a3e67431cd19a8f.jpg@240w_240h_1c_1s_!web-avatar-space-header.avif",
	"雨狸": "https://i1.hdslb.com/bfs/face/9acdc0d6c81f6f03d3830d6937efe831f9923400.jpg@240w_240h_1c_1s_!web-avatar-space-header.avif",
	"纯白": "https://i0.hdslb.com/bfs/face/06fa2af2e14b9e1b417792c9d5253766240510e1.jpg@240w_240h_1c_1s_!web-avatar-space-header.avif",
	"litterzy": "https://i1.hdslb.com/bfs/face/a9d5957e39815c03f4bf859fc8a28d3e9abdb895.jpg@240w_240h_1c_1s_!web-avatar-space-header.avif",
	"JUSF周存": "https://i1.hdslb.com/bfs/face/f8be673ab57ac98085fafb2bc36d03d59a94bd36.jpg@240w_240h_1c_1s_!web-avatar-space-header.avif"
}
var http_request = HTTPRequest.new()

func  _ready():
	if producer_img.has(GlobalScene.user_name):
		print("检测到P主名")
		GlobalScene.user_img = producer_img[GlobalScene.user_name]
	else:
		GlobalScene.user_img = preload("res://Resource/Img/user.jpeg")
	user_img.texture = GlobalScene.user_img
	
	"""
	if producer_img_link.has(GlobalScene.user_name):
		add_child(http_request)
		http_request.connect("request_completed", _on_image_request_completed)
		var error = http_request.request(producer_img_link[GlobalScene.user_name])
	"""
	
	user_name_label.text = GlobalScene.user_name
	version_label.text = GlobalScene.version
	
	user_name_label.max_lines_visible = GlobalScene.max_user_name_length
	user_name_label.visible_characters = GlobalScene.max_user_name_length


func _on_image_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var image = Image.new()
		if image.load_webp_from_buffer(body) == OK:
			var texture = ImageTexture.new()
			texture.create_from_image(image)
		else:
			print("图像加载失败")
	else:
		print("图像请求失败")




func _on_texture_rect_gui_input(event : InputEvent):
	if event.is_pressed():
		SceneChanger.change_scene("res://Scene/VisualScene/user_scene.tscn")
		print("进入 user_scene")


func _on_start_button_pressed():
	SceneChanger.change_scene("res://Scene/VisualScene/select_scene.tscn")
	print("进入 select_scene")


func _on_setting_button_pressed():
	SceneChanger.change_scene("res://Scene/VisualScene/setting_scene.tscn")
	print("进入 setting_scene")


func _on_quit_button_pressed():
	get_tree().quit()
