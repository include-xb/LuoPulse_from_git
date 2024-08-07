extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var time_dict: Dictionary = Time.get_time_dict_from_system()
	var time: String = str(time_dict["hour"]) + ":" + str(time_dict["minute"]) + ":" + str(time_dict["second"])
	text = time
