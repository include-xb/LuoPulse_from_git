extends HBoxContainer

var chartName: String = ""
var sequence: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_up(name, s) -> void:
	chartName = name
	sequence = s
	$MarginContainer/Label.text = chartName


func _on_button_pressed():
	DirAccess.remove_absolute("user://MscList/" + chartName)
	RunningData.chartList.remove_at(sequence)
	self.queue_free()
