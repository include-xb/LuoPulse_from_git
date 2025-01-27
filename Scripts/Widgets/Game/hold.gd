extends MeshInstance3D

class_name Hold

const original_z: float = 0.2

var packed_particle : PackedScene = preload("res://Scenes/Widgets/Game/gpu_particles_3d.tscn")

var scene : GameScene

var type : String = "hold"

# 每个音符的唯一标识符
var id : int = -1

var speed : float = 0.0

var timer : float = RunningData.delay_time

var column : int = 0

var duration : float = 0.0

var note_length : float = 0.0

var add : bool = false

var remove : bool = false

var is_holding : bool = false

# 摁住的过程中松开
var can_released : bool = false

var had_played_panel_animation : bool = false

# 摁住之后计时
var holding_timer : float = 0

var acc: int = 0

# 用于 autoplay
var is_hit : bool = false


# 更改长条不现实问题
var is_put: bool = false

var appear_time: float = 0.0


func _ready() -> void:
	speed = RunningData.speed
	position.y = 0.02


func _process(delta: float) -> void:
	
	# 在这里设置 hold 的初始坐标和长度
	if !is_put:
		note_length = duration * speed
		scale.z = note_length / original_z
		position.z -= note_length / 2
		is_put = true
	
	timer += delta
	position.z += speed * delta
	
	# 判定区间: 负 120ms 正 120ms
	if !add && timer >= -0.12:
		add = true
		RunningData.decision_area.push_back(self)
	
	# 开头直接 miss
	elif is_holding == false && \
			self in RunningData.decision_area && \
			!remove && timer >= 0.12:
		remove = true
		miss()
	
	if RunningData.is_auto_play:
		auto_play()
	
	# 摁住
	if is_holding:
		
		# 只执行一次
		if not had_played_panel_animation:
			had_played_panel_animation = true
			
			GlobalScene.hit_audio_player.play()
			
			# 吸附判定线
			var adjust: float = timer * speed
			position.z -= adjust
			# position.z += 0.65 # INFO: 0.65 为偏移量
			scale.z -= adjust / original_z
			timer = 0.0
			
		can_released = true
		holding_timer += delta
		
		if holding_timer >= duration:
			holding_timer = duration
			visible = false
			is_holding = false
		
		scale.z -= speed * delta / original_z
		position.z -= speed * delta / 2
		
	# 松开
	if !is_holding && can_released:
		can_released = false
		
		var score = holding_timer / duration
		
		# 摁住 95% 以上为 pure
		if score >= 0.95:
			RunningData.rating = "PURE"
			RunningData.pure_count += 1
			RunningData.combo += 1
			acc = 110
		
		# 摁住 85% - 95% 以上为 perfect
		elif score >= 0.85:
			RunningData.rating = "PERFECT"
			RunningData.perfect_count += 1
			RunningData.combo += 1
			acc = 100
		
		# 摁住 50% - 85% 为 great
		elif 0.5 <= score and score < 0.85:
			RunningData.rating = "GREAT"
			RunningData.great_count += 1
			RunningData.combo += 1
			acc = 50
		
		else:
			miss()
			return
		
		RunningData.accuracy = ((id - 1) * RunningData.accuracy + acc) / id


func miss():
	RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
	
	# INFO: miss
	RunningData.miss_count += 1
	RunningData.combo = 0
	RunningData.rating = "MISS"
	acc = 0
	RunningData.accuracy = (id * RunningData.accuracy + 0) / (id + 1)
	is_holding = false
	

func auto_play():
	if timer >= -0.01 and not is_hit:
		is_hit = true
		is_holding = true
		GlobalScene.hit_audio_player.play()
		get_node("../../track_panel" + str(column)).mesh.material.albedo_color = Color("333333d2")
	if timer >= duration:
		is_holding = false
		get_node("../../track_panel" + str(column)).mesh.material.albedo_color = Color("000000d2")
		self.queue_free()
