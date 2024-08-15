extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/CenterContainer2/VBoxContainer/VerName.text = RunningData.versionName
