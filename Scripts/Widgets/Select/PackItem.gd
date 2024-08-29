extends VBoxContainer

var pack_name: String

func set_up(name: String) -> void:
	var p_background: TextureRect = $PanelContainer/PackPic
	var name_label: Label = $PanelContainer/PackPic/MarginContainer/PackNameLabel
	
	p_background.texture = load("res://MscList/" + name + "/cover.png")
	name_label.text = name
	pack_name = name


func _on_button_pressed() -> void:
	RunningData.selected_pack_name = pack_name
	SceneChanger.change_scene("res://Scenes/Visual/Select/mselect_scene.tscn")
