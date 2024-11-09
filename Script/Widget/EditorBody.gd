extends VBoxContainer

var line_scene : PackedScene = preload("res://Scene/WidgetScene/line.tscn")


@onready var scroll_body : ScrollContainer = $".."
@onready var editor_body : VBoxContainer = $"."


@export var bpm : float = 120.0

@export var speed : float = 900.0

@export var min_division : float = 8

var bps : float = bpm / 60

var total_beat : int = 100

var note_height : float = 20.0

var distance : float

var is_head : bool = false


func _ready():
	distance = speed / bps / min_division
	
	for beat in range(total_beat):
		is_head = true
		for division in range(min_division):
			var instance : Line = line_scene.instantiate()
			
			instance.distance = distance
			instance.beat = beat
			instance.division = division
			instance.is_head = is_head
			
			editor_body.add_child(instance)
			var last_child = editor_body.get_children()[-1]
			editor_body.move_child(last_child, 0)
			
			is_head = false

	# TODO: 移动到 ScrollContainer 的最底部
	


func _process(delta):
	pass
