extends CharacterBody2D

class_name SINGLE_NOTE


@export var deathParticle : PackedScene = null

# 速度
var speed = 10

# 是否被放置
var is_set = false


func _ready():
	GlobalScene.is_running_note = false


# 物理下落
@warning_ignore("unused_parameter")
func _physics_process(delta):
	move_and_collide(velocity)


@warning_ignore("unused_parameter")
func _process(delta):
	if GlobalScene.is_running_note and !is_set:
		# 开始运行音符 (赋予音符下落速度)
		print("loaded")
		velocity.y = speed
		is_set = true


func kill():
	# 加载粒子效果
	var particle : PackedScene = preload("res://Scene/WidgetScene/gpu_particles_2d.tscn")
	var instance : GPUParticles2D = particle.instantiate()
	get_tree().current_scene.add_child(instance)
	
	instance.position = global_position
	instance.emitting = true
	queue_free()
