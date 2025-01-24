extends CanvasLayer


@onready var color_rect : ColorRect = $"背景"

@onready var animation_player : AnimationPlayer = $"黑场动画"

func _ready() -> void:
	color_rect.color = Color(0, 0, 0, 0)

# 场景路径, 转场颜色(默认黑色)
func change_scene(scene_path : String, color : Color = Color("000000")) -> void:
	color_rect.color = color
	animation_player.play("黑场")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(scene_path)
	animation_player.play_backwards("黑场")
