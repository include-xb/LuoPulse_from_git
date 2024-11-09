extends VBoxContainer

class_name Line

var track_note : PackedScene = preload("res://Scene/WidgetScene/track_note.tscn")

@onready var body : HBoxContainer = $Body

@onready var d : MarginContainer = $Body/d

@onready var separator_b : HSeparator = $HSeparatorB

@onready var separator_d : HSeparator = $HSeparatorD

var beat : float = 0

var division : float = 0

var distance : float = 1

var is_head : bool = false


func _ready():
	d.add_theme_constant_override("margin_top", distance)
	
	separator_b.visible = is_head
	separator_d.visible = !is_head
