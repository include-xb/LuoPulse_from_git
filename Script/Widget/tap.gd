extends Node2D

var packed_particle : PackedScene = preload("res://Scene/WidgetScene/gpu_particles_2d.tscn")

var speed : float = 0

var timer : float = 0

var column : int = 0

var add : bool = false

var remove : bool = false

func _ready():
	speed = GlobalScene.speed

func _process(delta):
	timer += delta
	position.y += speed * delta
	
	# 判定区间: 正负 0.2 秒
	if !add && timer >= GlobalScene.delay_time -0.2:
		add = true
		GlobalScene.decision_area.push_back(self)
		self.modulate = Color(120, 120, 120)
		
	elif !remove && timer >= GlobalScene.delay_time + 0.2:
		remove = true
		GlobalScene.decision_area.remove_at(GlobalScene.decision_area.find(self, 0))
		
		# INFO: missing
		
		self.queue_free()
	if GlobalScene.auto_play:
		auto_play()


func judge(hit_time : float):
	GlobalScene.decision_area.remove_at(GlobalScene.decision_area.find(self, 0))
	var adjust_time : float = abs(hit_time - timer)
	
	# perfect: 正负 0.05 秒
	if adjust_time <= 0.05:
		GlobalScene.perfect_count += 1
	else:
		GlobalScene.good_count += 1
	
	kill()


func auto_play():
	if timer >= GlobalScene.delay_time:
		GlobalScene.decision_area.remove_at(GlobalScene.decision_area.find(self, 0))
		kill()


func kill():
	GlobalScene.play_hit_audio()
	var instanced_particle : GPUParticles2D = packed_particle.instantiate()
	instanced_particle.global_position = self.global_position
	
	get_tree().current_scene.add_child(instanced_particle)
	instanced_particle.position = global_position
	instanced_particle.emitting = true
	self.queue_free()
