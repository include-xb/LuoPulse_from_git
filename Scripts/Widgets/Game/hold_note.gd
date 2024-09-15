extends MeshInstance3D

class_name Hold

var packed_particle : PackedScene = preload("res://Scenes/Widgets/Game/gpu_particles_3d.tscn")

var type : String = "hold"

var scene : GameScene

var speed : float = 0

var timer : float = 0

var column : int = 0

var duration : float = 0

var note_length : float = 0

var add : bool = false

var remove : bool = false

var is_holding : bool = false

var can_released : bool = false

# var had_played_panel_animation : bool = false

var holding_timer : float = 0

var id: int

# 用于 autoplay
var is_hit : bool = false

func _ready():
	speed = RunningData.speed
	
	note_length = duration * speed
	scale.y = note_length / 20
	position.y -= note_length / 2

func _process(delta):
	timer += delta
	position.y += speed * delta
	
	# 判定区间: 正负 125ms
	if !add && timer >= RunningData.delay_time - 0.125:
		add = true
		RunningData.decision_area.push_back(self)
	elif is_holding == false && self in RunningData.decision_area && !remove && timer >= RunningData.delay_time + 0.125:
		remove = true
		print("头判 miss")
		missing()
	
	if is_holding:
		#if not had_played_panel_animation:
			#scene.panel_animation.play("shake_down")
			#had_played_panel_animation = true
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
		
		scene.panel_animation.play_backwards("shake_down")
		
		var score = holding_timer / duration
		
		if score >= 0.85:
			RunningData.perfect_count += 1
			RunningData.rating = "perfect"
			RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
		elif 0.5 <= score and score < 0.85:
			RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
			RunningData.good_count += 1
			RunningData.rating = "good"
		else:
			print("中间 miss")
			missing()
	
	if RunningData.is_auto_play:
		auto_play()


func missing():
	RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
		
	# INFO: missing
	RunningData.missing_count += 1
	
	# RunningData.key_scene.current_holding = null
	is_holding = false
	RunningData.rating = "miss"
	
	# self.modulate = Color(1, 1, 1, 0.5)

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
	if timer >= RunningData.delay_time and not is_hit:
		#if not had_played_panel_animation:
			#had_played_panel_animation = true
			#scene.panel_animation.play("shake_down")
			
		is_hit = true
		is_holding = true
		# get_node("../../Panel/Panel_" + str(column)).modulate = Color(1, 1, 1, 0.5)
		#scene.panel_animation.get_node("../Panel_" + str(column)).modulate = Color(1, 1, 1, 0.5)
		
		RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
		dead_particle()
		# self.visible = false
		
	if timer >= RunningData.delay_time + duration:
		is_holding = false
		# scene.panel_animation.play_backwards("shake_down")
		RunningData.perfect_count += 1
		RunningData.rating = "perfect"
		self.queue_free()
		# get_node("../../Panel/Panel_" + str(column)).modulate = Color(1, 1, 1, 1)
		# scene.panel_animation.get_node("../Panel_" + str(column)).modulate = Color(1, 1, 1, 1)


func dead_particle():
	# GlobalScene.play_hit_audio()
	
	var instanced_particle : GPUParticles3D = packed_particle.instantiate()
	get_tree().current_scene.add_child(instanced_particle)
	instanced_particle.global_position.x = self.global_position.x
	instanced_particle.global_position.y = self.global_position.y + 20 * scale.y / 2
	instanced_particle.emitting = true
	
