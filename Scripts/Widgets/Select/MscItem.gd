extends Button

var parent: Control
var index: int

func set_up(msc_name: String, index: int, parent: Control, path: String) -> void:
	$MarginContainer/VBoxContainer/NameLabel.text = msc_name
	$MarginContainer/VBoxContainer/ArLabel.text = Utils.get_short_artists_list(path)
	self.parent = parent
	self.index = index
	
	if self.index == 0:
		self.disabled = true


func _on_pressed() -> void:
	parent.on_selected(index)
