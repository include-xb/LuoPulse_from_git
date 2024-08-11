extends Area2D

@onready var tip_label : Label = $"../PlayPanel/TipLabel"

@onready var tip_animation_player : AnimationPlayer = $"../PlayPanel/TipLabel/AnimationPlayer"

# 音符超过判定线, 删除音符
func _on_body_entered(body : SINGLE_NOTE):
	tip_animation_player.stop()
	tip_label.text = "MISSING"
	tip_animation_player.play("fadeout")
	
	#missing 计数加 1
	GlobalScene.missing_count += 1
	body.queue_free()
