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

var acc: int = 0


func _ready():
	velosity.z = RunningData.speed # 实际上, 音符速度 和 流速 之间是一个线性方程, 此处暂时省略, 直接赋值
	position.y = 0.02 # y 坐标不变

var temp = true

func _process(delta):
	position += velosity * delta
	
	timer += delta
	
	if RunningData.is_auto_play:
		auto_play()
	
	elif !add && timer >= -0.12:
		add = true
		RunningData.decision_area.push_back(self)
	# miss
	elif !remove && timer >= 0.12:
		miss()
		return
		


func miss() -> void:
	remove = true
	RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
	
	RunningData.miss_count += 1
	RunningData.combo = 0
	RunningData.rating = "MISS"
	RunningData.accuracy = (id * RunningData.accuracy + 0) / (id + 1)
	self.queue_free()
	

func judge():
	#if self in RunningData.decision_area:
		#RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
	GlobalScene.hit_audio_player.play()
	
	RunningData.combo += 1
	
	var diff: float = abs(timer)
	
	if diff <= 0.03:
		RunningData.pure_count += 1
		RunningData.rating = "PURE"
		acc = 110
	elif diff <= 0.06:
		RunningData.perfect_count += 1
		RunningData.rating = "PERFECT"
		acc = 100
	elif diff <= 0.09:
		RunningData.great_count += 1
		RunningData.rating = "GREAT"
		acc = 50
	elif diff <= 0.12:
		RunningData.good_count += 1
		RunningData.rating = "GOOD"
		acc = 25
	else:
		acc = 0
	
	RunningData.accuracy = ((id - 1) * RunningData.accuracy + acc) / id
	
	#self.queue_free()

func auto_play():
	if timer >= -0.01 and temp:
		GlobalScene.hit_audio_player.play()
		get_node("../../track_panel" + str(column)).mesh.material.albedo_color = Color("333333d2")
		judge()
		self.visible = false
		temp = false
	if timer >= 0.1:
		get_node("../../track_panel" + str(column)).mesh.material.albedo_color = Color("000000d2")
		kill()


func kill():
	#if self in RunningData.decision_area:
		#RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
	queue_free()
