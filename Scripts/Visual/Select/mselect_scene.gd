extends Control

@onready var msc_list_view: VBoxContainer = $VBoxContainer/MarginContainer2/HBoxContainer/MarginContainer/ScrollContainer/List
var msc_path: String
var items: Array[Button] = []
var msc: Array[Dictionary] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var pack_name = RunningData.selected_pack_name
	var msc_name_list: Array[String] = RunningData.mscPackList[pack_name]
	$VBoxContainer/HBoxContainer/MarginContainer2/PanelContainer/Label.text = pack_name
	for i in msc_name_list.size():
		var msc_name = msc_name_list[i]
		var path: String = Constant.ROOT_PATH + "/" + "pack_name" + msc_name
		msc.append(
			{
				"name": msc_name,
				"path": path
			}
		)
		var item: Node = preload("res://Scenes/Widgets/Select/MscItem.tscn").instantiate()
		item.set_up(msc_name, i, self, path)
		items.append(item)
		msc_list_view.add_child(item)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Visual/Select/pselect_scene.tscn")


func on_selected(index: int) -> void:
	for i in items.size():
		if i == index:
			items[i].disabled = true
		else:
			items[i].disabled = false
