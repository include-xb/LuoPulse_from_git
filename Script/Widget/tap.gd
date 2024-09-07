extends Node2D

var packed_particle : PackedScene = preload("res://Scene/WidgetScene/gpu_particles_2d.tscn")

var type : String = "tap"

var speed : float = 0

var timer : float = 0

var column : int = 0

var duration : float = 0

var add : bool = false

var remove : bool = false

# 用于 autoplay
var is_hit : bool = false

func _ready():
	speed = GlobalScene.speed

func _process(delta):
	timer += delta
	position.y += speed * delta
	
	# 判定区间: 正负 125ms
	if !add && timer >= GlobalScene.delay_time -0.125:
		add = true
		GlobalScene.decision_area.push_back(self)
		self.modulate = Color(120, 120, 120)
		
	elif !remove && timer >= GlobalScene.delay_time + 0.125:
		remove = true
		GlobalScene.decision_area.remove_at(GlobalScene.decision_area.find(self, 0))
		
		# INFO: missing
		GlobalScene.miss_count += 1
		
		self.queue_free()
	
	if GlobalScene.auto_play:
		auto_play()


func judge(hit_time : float):
	GlobalScene.decision_area.remove_at(GlobalScene.decision_area.find(self, 0))
	var adjust_time : float = abs(timer - GlobalScene.delay_time)
	# perfect: 正负 50ms
	if adjust_time <= 0.05:
		GlobalScene.perfect_count += 1
	else:
		GlobalScene.good_count += 1
	
	dead_particle()
	self.queue_free()


func auto_play():
	if timer >= GlobalScene.delay_time and not is_hit:
		is_hit = true
		get_node("../../Panel/Panel_" + str(column)).modulate = Color(1, 1, 1, 0.5)
		GlobalScene.decision_area.remove_at(GlobalScene.decision_area.find(self, 0))
		dead_particle()
		GlobalScene.perfect_count += 1
		self.visible = false
		
	if timer >= GlobalScene.delay_time + 0.1:
		self.queue_free()
		get_node("../../Panel/Panel_" + str(column)).modulate = Color(1, 1, 1, 1)


func dead_particle():
	GlobalScene.play_hit_audio()
	var instanced_particle : GPUParticles2D = packed_particle.instantiate()
	
	get_tree().current_scene.add_child(instanced_particle)
	instanced_particle.global_position = self.global_position
	instanced_particle.emitting = true
	
