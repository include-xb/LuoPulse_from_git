extends CanvasLayer

@onready var color_rect : ColorRect = $ColorRect


@onready var animation_player : AnimationPlayer = $ColorRect/AnimationPlayer


# 场景路径, 转场颜色(默认黑色)
func change_scene(scene_path : String, color : Color = Color("000000")):
	color_rect.color = color
	animation_player.play("change_scene")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(scene_path)
	animation_player.play_backwards("change_scene")
