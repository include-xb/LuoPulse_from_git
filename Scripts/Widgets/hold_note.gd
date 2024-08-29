"""extends MeshInstance3D


class_name HoldNote

# 已弃用 shared_class_name 判定音符独特标志
var shared_class_name : String = "HoldNote"

# 每个音符特有标志, (后续可能会用到)
var id : int = -1

# 音符种类: tap / hold, 这个变量在 note_loader 中被初始化
var type : StringName = ""

var velosity : Vector3 = Vector3.ZERO

# 音符到达判定线的时间, 这个变量在 note_loader 中被初始化
var appear_time : float = 0

# 音符从被放置就开始计时
var running_timer : float = RunningData.delay_time

var add : bool = true
var remove : bool = true

var duration : float = 0
# 引用 game_scene 场景, 这个引用在 note_loader 中被初始化
#var placed_scene : GameScene


func _ready():
	velosity.z = RunningData.speed # 实际上, 音符速度 和 流速 之间是一个线性方程, 此处暂时省略, 直接赋值
	position.y = 0.4 # y 坐标不变

var temp = true

func _process(delta):
	position += velosity * delta
	
	running_timer += delta
	
	# INFO: 音符判定区间: 负0.2秒 - 正0.08秒
	if add && running_timer >= -0.2:
		add = false
		RunningData.decision_area.push_back(self)
		#position.y = 0.2
		#print(RunningData.decision_area.size())
	elif remove && running_timer >= 0.2:
		remove = false
		#position.y = 0.4
		RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
		
		# TODO: MISSING 部分
		RunningData.missing_count += 1
		mesh.material.albedo_color = Color(102, 204, 255, 0.3)
		#print(RunningData.decision_area.size())
	
	if running_timer >= 0:
		mesh.size.z - RunningData.speed * delta
		position.z -= RunningData.speed * delta / 2
	
	if running_timer >= 0.2 + duration:
		queue_free()
	
	if RunningData.is_auto_play:
		auto_play()


func judge_note(touch_position : Vector3) -> bool:
	var z = abs(position.z - touch_position.z)
	#var x = abs(position.x - touch_position.x)
	
	if z <= 1:
		
		# TODO: 计分
		
		kill()
		return true
	return false


func auto_play():
	if position.z >= 0 and temp:
		velosity = Vector3.ZERO
		RunningData.perfect_count += 1
		kill()
		temp = false


func kill():
	RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
	# TODO: 点击效果...
	# $MeshInstance3D.mesh.material.albedo_color = Color(102, 204, 255)
	GlobalScene.play_hit_audio()
	
	queue_free()
"""


extends Note

class_name HoldNote

# 长按音符的持续时间，这个变量在 note_loader 中被初始化
var duration : float = 0

# 长按音符的判定状态
var is_held := false


func _ready():
	velosity.z = RunningData.speed
	# 设置长按音符的初始状态
	is_held = false
	# 长按音符可能不需要立即加入判定区间，具体取决于你的时间逻辑
	# add = false
	# 你可能需要一个计时器来处理长按的逻辑
	$HoldTimer.start(duration)

func _process(delta):
	# 调用父类_process方法
	# get_parent()._process(delta)
	
	position += velosity * delta
	
	running_timer += delta
	
	# INFO: 音符判定区间: 负0.2秒 - 正0.08秒
	if add && running_timer >= -0.2:
		add = false
		RunningData.decision_area.push_back(self)
		#position.y = 0.2
		#print(RunningData.decision_area.size())
	elif remove && running_timer >= 0.2:
		remove = false
		#position.y = 0.4
		RunningData.decision_area.remove_at(RunningData.decision_area.find(self, 0))
		
		# TODO: MISSING 部分
		RunningData.missing_count += 1
		queue_free()
		#print(RunningData.decision_area.size())
	
	if RunningData.is_auto_play:
		auto_play()
	
	
	# 处理长按音符的判定逻辑
	if not is_held and running_timer >= 0:
		# 如果长按音符到达判定线，并且尚未开始判定
		if judge_note(position):
			is_held = true
			# 长按音符在判定区间内，不需要移除
			remove = false
			# 可以在这里添加一些视觉反馈，比如改变颜色或者播放特效

func _input(event):
	# 处理输入事件，用于长按音符的释放
	if event is InputEventScreenTouch and not event.pressed and is_held:
		# 如果触摸释放并且长按音符正在被判定
		if abs(RunningData.current_audio_time - appear_time) <= 0.05:
			# 如果在正确的时间内释放，判定为完美
			RunningData.perfect_count += 1
		else:
			# 如果在错误的时间释放，判定为好
			RunningData.good_count += 1
		is_held = false
		# 恢复长按音符的移除逻辑
		remove = true

func judge_note(touch_position : Vector3) -> bool:
	# 长按音符的判定逻辑可能与普通音符不同
	# 这里需要判断触摸是否在长按音符的持续时间内
	var z = abs(position.z - touch_position.z)
	if z <= 1 and running_timer >= 0 and not is_held:
		return true
	return false

# 使用Timer节点处理长按逻辑
var hold_timer : Timer

func _on_HoldTimer_timeout():
	# 当长按时间到时，如果玩家还在按住
	if is_held:
		# 判定为完美
		RunningData.perfect_count += 1
		# 停止长按逻辑
		is_held = false
		# 恢复移除逻辑
		remove = true
		# 可以在这里添加一些视觉和音效反馈
