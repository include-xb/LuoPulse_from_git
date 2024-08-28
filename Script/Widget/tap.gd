extends Node2D


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
		self.queue_free()
		GlobalScene.play_hit_audio()


func kill():
	pass
