extends Node2D

class_name Hold

var packed_particle : PackedScene = preload("res://Scene/WidgetScene/gpu_particles_2d.tscn")

var scene : PlayScene

var type : String = "hold"

# 每个音符的唯一标识符
var id : int = -1

var speed : float = 0

var timer : float = 0

var column : int = 0

var duration : float = 0

var note_length : float = 0

var add : bool = false

var remove : bool = false

var is_holding : bool = false

# 摁住的过程中松开
var can_released : bool = false

var had_played_panel_animation : bool = false

# 摁住之后计时
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
	
	# 判定区间: 负 120ms 正 120ms
	if !add && timer >= GlobalScene.delay_time - 0.12:
		add = true
		GlobalScene.decision_area.push_back(self)
	
	# 开头直接 miss
	elif is_holding == false && self in GlobalScene.decision_area && !remove && timer >= GlobalScene.delay_time + 0.12:
		remove = true
		missing()
	
	# 摁住
	if is_holding:
		if not had_played_panel_animation:
			had_played_panel_animation = true
			scene.panel_animation.play("shake_down")
			GlobalScene.play_hit_audio()
			
			# 吸附判定线
			var adjust : float = (timer - GlobalScene.delay_time) * speed
			scale.y = (note_length - adjust) / 20
			position.y -= adjust / 2
			
		can_released = true
		holding_timer += delta
		
		if holding_timer >= duration:
			holding_timer = duration
			visible = false
			is_holding = false
		
		scale.y -= speed * delta / 20
		position.y -= speed * delta / 2
		
		dead_particle()
	
	# 松开
	if !is_holding && can_released:
		can_released = false
		
		scene.panel_animation.play_backwards("shake_down")
		
		var score = holding_timer / duration
		
		# 摁住 85% 为 perfect
		if score >= 0.85:
			GlobalScene.perfect_count += 1
			if self in GlobalScene.decision_area:
				GlobalScene.decision_area.remove_at(GlobalScene.decision_area.find(self, 0))
		# 摁住 50% - 85% 为 good
		elif 0.5 <= score and score < 0.85:
			if self in GlobalScene.decision_area:
				GlobalScene.decision_area.remove_at(GlobalScene.decision_area.find(self, 0))
			GlobalScene.good_count += 1
		else:
			# print("中间 miss")
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


func auto_play():
	if timer >= GlobalScene.delay_time and not is_hit:
		if not had_played_panel_animation:
			had_played_panel_animation = true
			scene.panel_animation.play("shake_down")
			GlobalScene.play_hit_audio()
			
		is_hit = true
		is_holding = true
		scene.panel_animation.get_node("../Panel_" + str(column)).modulate = Color(1, 1, 1, 0.5)
		
		GlobalScene.decision_area.remove_at(GlobalScene.decision_area.find(self, 0))
		dead_particle()
		
	if timer >= GlobalScene.delay_time + duration:
		is_holding = false
		scene.panel_animation.play_backwards("shake_down")
		GlobalScene.perfect_count += 1
		self.queue_free()
		scene.panel_animation.get_node("../Panel_" + str(column)).modulate = Color(1, 1, 1, 1)


func dead_particle():
	var instanced_particle : GPUParticles2D = packed_particle.instantiate()
	get_tree().current_scene.add_child(instanced_particle)
	instanced_particle.global_position.x = self.global_position.x
	instanced_particle.global_position.y = self.global_position.y + 20 * scale.y / 2
	instanced_particle.emitting = true
	
