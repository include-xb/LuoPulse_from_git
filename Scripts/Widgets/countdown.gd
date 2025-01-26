extends Label

var is_counting: bool = false

var from: float = 3.0


func _ready() -> void:
	from = 3.0


func start() -> void:
	get_tree().paused = true
	self.visible = true
	is_counting = true


func _process(delta: float) -> void:
	if is_counting == true:
		from -= delta
		self.text = str(round(from))
	
		if from <= 1:
			get_tree().paused = false
			
			is_counting = false
			_ready()
			self.visible = false
