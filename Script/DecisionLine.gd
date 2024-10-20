extends Area2D

# 提示 Perfect 标签
@onready var tip_label = $"../TipLabel"

# 提示标签的淡出动画
@onready var tip_animation_player = $"../TipLabel/AnimationPlayer"


@warning_ignore("unused_parameter")
func _on_body_entered(body):
	return
	tip_animation_player.stop()
	tip_label.text = "MISSING"
	tip_animation_player.play("fadeout")
	
	#missing 计数加 1
	GlobalScene.missing_count += 1
