extends Area2D


# 四个键位
@export_enum("D", "F", "J", "K" ) var POS: String

# 提示 Perfect 标签
@onready var tip_label = $"../../TipLabel"

# 提示标签的淡出动画
@onready var tip_animation_player : AnimationPlayer = $"../../TipLabel/AnimationPlayer"

# 音符是否进入判断区
var able_to_judge = false

# 当前进入判定区的音符
var current_body : SINGLE_NOTE


@warning_ignore("unused_parameter")
func _process(delta):
	
	# 对应键位按下
	if Input.is_action_pressed("PS_" + POS):
		
		# 对应轨道变透明
		get_node("../../../BackPanel/Panel" + POS).modulate = Color(1, 1, 1, 0.5)
		
		if !able_to_judge:
			return
		
		# 播放打击音符的音效
		GlobalScene.play_hit_audio()
		
		#对于 perfect 的判定
		if abs(current_body.position.y - 185) <= 10.5:
			# perfect 计数加 1
			GlobalScene.perfect_count += 1
			
			# perfect 标签显示
			tip_animation_player.stop()
			tip_label.text = "PERFECT"
			tip_animation_player.play("fadeout")
		else:
			tip_animation_player.stop()
			tip_label.text = "GOOD"
			tip_animation_player.play("fadeout")
			
			# good 计数加 1
			GlobalScene.good_count += 1
		# 音符被点击后的粒子效果
		current_body.kill()
	
	else:
		# 轨道颜色重置
		get_node("../../../BackPanel/Panel"+POS).modulate = Color(1, 1, 1, 1)


# 如果有音符进入判定区, 开始判定
func _on_body_entered(body):
	able_to_judge = true
	current_body = body


# 音符离开判定区, 结束判断
@warning_ignore("unused_parameter")
func _on_body_exited(body):
	able_to_judge = false
