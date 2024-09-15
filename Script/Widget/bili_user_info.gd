extends HTTPRequest

class_name BiliUserInof

func _ready():
	get_user_info("112428")

# 异步函数，接受UID作为参数，返回用户名和头像链接
func get_user_info(uid : String) -> void:
	var api_url = "http://api.bilibili.cn/userinfo?uid=" + uid
	var headers : PackedStringArray = [
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0" # 添加自定义User-Agent
	]
	var error = self.request(api_url, headers)
	print("error: ", error)
	print("开始request")
	
	# 连接信号以获取请求完成的回调
	self.connect("request_completed", _on_user_info_request_completed)

# 处理请求完成的回调
func _on_user_info_request_completed(result, response_code, headers, body):
	print("获取到返回值")
	if response_code == 200:
		var response = JSON.parse_string(body.get_string_from_utf8())
		if response.error == OK and response.result.code == 200:
			var user_info = {
				"user_name": response.result.data.name,
				"avatar_url": response.result.data.avatar
			}
			# 这里你可以根据需要处理用户信息，例如打印输出或者存储起来
			print("user_info: ", user_info)
			# 如果你需要返回这个信息，你可能需要使用信号或者存储在某个地方
		else:
			print("Error fetching user info: ", response.result.message)
	else:
		print("HTTP Request failed with status code: ", response_code)
