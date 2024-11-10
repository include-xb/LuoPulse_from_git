extends MeshInstance3D

class_name Hold

var packed_particle : PackedScene = preload("res://Scenes/Widgets/Game/gpu_particles_3d.tscn")

var scene : GameScene

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
	speed = RunningData.speed
	
	note_length = duration * speed
	scale.z = note_length / 20
	position.z -= note_length / 2

func _process(delta):
	timer += delta
	position.z += speed * delta
	
	# 判定区间: 负 120ms 正 120ms
	if !add && timer >= RunningData.delay_time - 0.12:
		add = true
		RunningData.decision_area.push_back(self)
	
	# 开头直接 miss
	elif is_holding == false && \
			self in RunningData.decision_area && \
			!remove && timer >= RunningData.delay_time + 0.12:
		remove = true
		missing()
	
	# 摁住
	if is_holding:
		if not had_played_panel_animation:
			had_played_panel_animation = true
			
			# 吸附判定线
			var adjust : float = (timer - RunningData.delay_time) * speed
			scale.z = (note_length - adjust) / 20
			position.z -= adjust / 2
			
		can_released = true
		holding_timer += delta
		
		if holding_timer >= duration:
			holding_timer = duration
			visible = false
			is_holding = false
		
		scale.z -= speed * delta / 20
		position.z -= speed * delta / 2
		
	
	# 松开
	if !is_holding && can_released:
		can_released = false
				
		var score = holding_timer / duration
		
		# 摁住 85% 为 perfect
		if score >= 0.85:
			if self in RunningData.decision_area:
				RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
			RunningData.perfect_count += 1
			RunningData.combo += 1
		
		# 摁住 50% - 85% 为 good
		elif 0.5 <= score and score < 0.85:
			if self in RunningData.decision_area:
				RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
			RunningData.good_count += 1
			RunningData.combo += 1
		else:
			missing()
		
	
	if RunningData.is_auto_play:
		auto_play()


func missing():
	RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
	
	# INFO: missing
	RunningData.missing_count += 1
	RunningData.combo = 0
	
	#RunningData.key_scene.current_holding = null
	is_holding = false
	

func auto_play():
	if timer >= RunningData.delay_time and not is_hit:
		if not had_played_panel_animation:
			had_played_panel_animation = true
			
		is_hit = true
		is_holding = true		
		RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))

	if timer >= RunningData.delay_time + duration:
		is_holding = false
		
		RunningData.pure_count += 1
		RunningData.combo += 1
		
		self.queue_free()
