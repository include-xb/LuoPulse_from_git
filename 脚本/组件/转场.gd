extends CanvasLayer


@onready var animation_player : AnimationPlayer = $"动画"


# 场景路径, 转场颜色(默认黑色)
func change_scene(scene_path : String) -> void:
	animation_player.play("渐入")
	await animation_player.animation_finished
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file(scene_path)
	animation_player.play("渐出")
	#await animation_player.animation_finished
