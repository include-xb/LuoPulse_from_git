extends Node2D

var packed_particle : PackedScene = preload("res://Scene/WidgetScene/gpu_particles_2d.tscn")

var speed : float = 0

var timer : float = 0

var add : bool = false

var remove : bool = false

func _ready():
	speed = GlobalScene.speed

func _process(delta):
	timer += delta
	position.y += speed * delta
	
	if !add && timer >= GlobalScene.delay_time -0.6:
		add = true
		GlobalScene.decision_area.push_back(self)
		
	elif !remove && timer >= GlobalScene.delay_time + 0.6:
		remove = true
		GlobalScene.decision_area.remove_at(GlobalScene.decision_area.find(self, 0))
		
		# missing
	if GlobalScene.auto_play:
		auto_play()


func auto_play():
	if timer >= GlobalScene.delay_time:
		GlobalScene.decision_area.remove_at(GlobalScene.decision_area.find(self, 0))
		GlobalScene.play_hit_audio()
		
		var instanced_particle : GPUParticles2D = packed_particle.instantiate()
		instanced_particle.global_position = self.global_position
		
		get_tree().current_scene.add_child(instanced_particle)
		instanced_particle.position = global_position
		instanced_particle.emitting = true
		self.queue_free()


func kill():
	pass
