extends MeshInstance3D

class_name Tap

var type : String = "tap"

var velosity : Vector3 = Vector3.ZERO

var id: int

# 音符从被放置就开始计时
var timer : float = RunningData.delay_time

var add : bool = false

var remove : bool = false

var column: int

var appear_time: float


func _ready():
	velosity.z = RunningData.speed # 实际上, 音符速度 和 流速 之间是一个线性方程, 此处暂时省略, 直接赋值
	position.y = 0.02 # y 坐标不变

var temp = true

func _process(delta):
	position += velosity * delta
	
	timer += delta
	
	if RunningData.is_auto_play:
		auto_play()
	elif !add && timer >= -0.2:
		add = true
		RunningData.decision_area.push_back(self)
	# miss
	elif !remove && timer >= 0.2:
		remove = true
		RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
		
		RunningData.miss_count += 1
		RunningData.combo = 0
		RunningData.rating = "MISS"
		self.queue_free()


func judge():
	RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
	var diff : float = appear_time - RunningData.world_timer
		
	if diff <= 0.03:
		GlobalScene.hit_audio_player.play()
		RunningData.pure_count += 1
		RunningData.combo += 1
		RunningData.score += RunningData.single_note_score
		RunningData.rating = "PURE"
	
	elif diff <= 0.06:
		GlobalScene.hit_audio_player.play()
		RunningData.perfect_count += 1
		RunningData.combo += 1
		RunningData.score += RunningData.single_note_score * 0.9
		RunningData.rating = "PERFECT"
		
	elif diff <= 0.09:
		GlobalScene.hit_audio_player.play()
		RunningData.great_count += 1
		RunningData.combo += 1
		RunningData.score += RunningData.single_note_score * 0.7
		RunningData.rating = "GREAT"
		
	elif diff <= 0.12:
		GlobalScene.hit_audio_player.play()
		RunningData.good_count += 1
		RunningData.combo += 1
		RunningData.score += RunningData.single_note_score * 0.5
		RunningData.rating = "GOOD"
		
	else:
		RunningData.miss_count += 1
		RunningData.combo = 0
		RunningData.rating = "MISS"

	
	self.queue_free()


func auto_play():
	if timer >= 0 and temp:
		GlobalScene.hit_audio_player.play()
		get_node("../../track_panel" + str(column)).mesh.material.albedo_color = Color("333333d2")
		
		
		velosity = Vector3.ZERO
		RunningData.pure_count += 1
		RunningData.combo += 1
		RunningData.rating = "PURE"
		RunningData.score += RunningData.single_note_score
		# kill()
		self.visible = false
		temp = false
		# get_node("../../track_panel" + str(column)).mesh.material.albedo_color = Color("000000d2")
	#
	if timer >= 0.1:
		get_node("../../track_panel" + str(column)).mesh.material.albedo_color = Color("000000d2")
		kill()


func kill():
	if self in RunningData.decision_area:
		RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
	queue_free()
