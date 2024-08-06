extends Area2D


# 音符超过判定线, 删除音符
func _on_body_entered(body):
	body.queue_free()
