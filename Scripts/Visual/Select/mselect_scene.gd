extends Control

@onready var msc_list_view: VBoxContainer = $VBoxContainer/MarginContainer2/HBoxContainer/MarginContainer/ScrollContainer/List
@onready var texture_rect: TextureRect = $VBoxContainer/MarginContainer2/HBoxContainer/VBoxContainer/CenterContainer/TextureRect
@onready var bg_texture_rect: TextureRect = $TextureRect
@onready var player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var auto_play_setting_button: Button = $ModSetting/VBoxContainer/MarginContainer/VBoxContainer/AutoplaySetting/MarginContainer/HBoxContainer/AutoPlaySettingButton
@onready var mod_panel: Panel = $ModSetting

# 曲目列表路径
var msc_list_path: String
# 视图中的列表项
var items: Array[Button] = []
# 曲目列表
var msc: Array[Dictionary] = []
# 已选择的项目索引
var selected_index: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 当前曲包名
	var pack_name = RunningData.selected_pack_name
	msc_list_path = Constant.ROOT_PATH + "/" + pack_name
	
	if RunningData.is_auto_play:
		auto_play_setting_button.text = "开"
	else:
		auto_play_setting_button.text = "关"
	
	# 曲名列表
	var msc_name_list: Array[String] = RunningData.pack_list[pack_name]
	$VBoxContainer/HBoxContainer/MarginContainer2/PanelContainer/Label.text = pack_name
	# 添加项目至列表
	for i in msc_name_list.size():
		var msc_name = msc_name_list[i]
		var path: String = msc_list_path + "/" + msc_name
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
		
	# 默认选择列表第一项
	_select(0)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Visual/Select/pselect_scene.tscn")


func on_selected(index: int) -> void:
	_select(index)
	for i in items.size():
		if i == index:
			items[i].disabled = true
		else:
			items[i].disabled = false


# 选择
func _select(index: int) -> void:
	selected_index = index
	if player.playing == true:
		player.stop()
	var select_path: String = msc[index]["path"]
	var bg_texture = load(select_path + "/cover.png")
	bg_texture_rect.texture = bg_texture
	texture_rect.texture = bg_texture
	player.stream = load(select_path + "/audio.mp3")
	player.play()


func _on_start_button_pressed() -> void:
	RunningData.selected_msc = msc[selected_index]
	get_tree().change_scene_to_file("res://Scenes/Visual/game_scene.tscn")


func _on_auto_play_setting_button_pressed() -> void:
	if RunningData.is_auto_play:
		RunningData.is_auto_play = false
		auto_play_setting_button.text = "关"
	else:
		RunningData.is_auto_play = true
		auto_play_setting_button.text = "开"


func _on_mod_close_button_pressed() -> void:
	mod_panel.visible = false


func _on_mod_button_pressed() -> void:
	mod_panel.visible = true
