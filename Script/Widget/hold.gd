extends Node2D

class_name Hold

var packed_particle : PackedScene = preload("res://Scene/WidgetScene/gpu_particles_2d.tscn")

var type : String = "hold"

var speed : float = 0

var timer : float = 0

var column : int = 0

var duration : float = 0

var note_length : float = 0

var add : bool = false

var remove : bool = false

var is_holding : bool = false

var can_released : bool = false

var holding_timer : float = 0

# 用于 autoplay
var is_hit : bool = false

func _ready():
	speed = GlobalScene.speed
	
	note_length = duration * speed
	scale.y = note_length / 20
	position.y -= note_length / 2

func _process(delta):
	timer += delta
	position.y += speed * delta
	
	# 判定区间: 正负 125ms
	if !add && timer >= GlobalScene.delay_time - 0.125:
		add = true
		GlobalScene.decision_area.push_back(self)
		
	elif is_holding == false && self in GlobalScene.decision_area && !remove && timer >= GlobalScene.delay_time + 0.125:
		remove = true
		print("头判 miss")
		missing()
	
	if is_holding:
		can_released = true
		holding_timer += delta
		
		if holding_timer >= duration:
			holding_timer = duration
			is_holding = false
		
		scale.y -= speed * delta / 20
		position.y -= speed * delta / 2
		
		dead_particle()
	
	if !is_holding && can_released:
		can_released = false
		var score = holding_timer / duration
		
		if score >= 0.85:
			GlobalScene.perfect_count += 1
			GlobalScene.decision_area.remove_at(GlobalScene.decision_area.find(self, 0))
		elif 0.5 <= score and score < 0.85:
			GlobalScene.decision_area.remove_at(GlobalScene.decision_area.find(self, 0))
			GlobalScene.good_count += 1
		else:
			print("中间 miss")
			missing()
	
	if GlobalScene.auto_play:
		auto_play()


func missing():
	GlobalScene.decision_area.remove_at(GlobalScene.decision_area.find(self, 0))
		
	# INFO: missing
	GlobalScene.miss_count += 1
	
	GlobalScene.key_scene.current_holding = null
	is_holding = false
	
	self.modulate = Color(1, 1, 1, 0.5)

"""
func judge(hit_time : float):
	GlobalScene.decision_area.remove_at(GlobalScene.decision_area.find(self, 0))
	
	var adjust_time : float = abs(timer - GlobalScene.delay_time)
	# perfect: 正负 50ms
	if adjust_time <= 0.05:
		GlobalScene.perfect_count += 1
	else:
		GlobalScene.good_count += 1
	
	# dead_particle()
	
	# self.queue_free()
"""

# INFO: hold autoplay 未完
func auto_play():
	if timer >= GlobalScene.delay_time and not is_hit:
		is_hit = true
		get_node("../../Panel/Panel_" + str(column)).modulate = Color(1, 1, 1, 0.5)
		GlobalScene.decision_area.remove_at(GlobalScene.decision_area.find(self, 0))
		dead_particle()
		GlobalScene.perfect_count += 1
		# self.visible = false
		
	if timer >= GlobalScene.delay_time + duration:
		self.queue_free()
		get_node("../../Panel/Panel_" + str(column)).modulate = Color(1, 1, 1, 1)


func dead_particle():
	# GlobalScene.play_hit_audio()
	
	var instanced_particle : GPUParticles2D = packed_particle.instantiate()
	get_tree().current_scene.add_child(instanced_particle)
	instanced_particle.global_position.x = self.global_position.x
	instanced_particle.global_position.y = self.global_position.y + 20 * scale.y / 2
	instanced_particle.emitting = true
	
