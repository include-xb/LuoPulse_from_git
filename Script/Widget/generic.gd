extends MarginContainer

@export var Hesitate : bool = true
@export var Path : bool = true
@export var Speed : bool = true
@export var BGLight : bool = true
@export var Volume : bool = true
@export var AutoPlay : bool = true

@onready var hesitate_body : MarginContainer = $ScrollContainer/VBoxContainer/HesitateSetting
@onready var path_body : MarginContainer = $ScrollContainer/VBoxContainer/PathSetting
@onready var speed_body : MarginContainer = $ScrollContainer/VBoxContainer/SpeedSetting
@onready var bglight_body : MarginContainer = $ScrollContainer/VBoxContainer/BGLightSetting
@onready var volume_body : MarginContainer = $ScrollContainer/VBoxContainer/VolumeSetting
@onready var autoplay_body : MarginContainer = $ScrollContainer/VBoxContainer/AutoPlaySetting


@onready var hesitate_spin_box : SpinBox = $ScrollContainer/VBoxContainer/HesitateSetting/HBoxContainer/SpinBox

@onready var path_line_edit : LineEdit = $ScrollContainer/VBoxContainer/PathSetting/HBoxContainer/PathLineEdit

# -20 ~ 20
@onready var speed_label : Label = $ScrollContainer/VBoxContainer/SpeedSetting/HBoxContainer/VBoxContainer/SpeedLabel

@onready var speed_slider : HSlider = $ScrollContainer/VBoxContainer/SpeedSetting/HBoxContainer/VBoxContainer/SpeedHSlider

@onready var bglight_slider : HSlider = $ScrollContainer/VBoxContainer/BGLightSetting/HBoxContainer/BglightHSlider

@onready var volume_slider : HSlider = $ScrollContainer/VBoxContainer/VolumeSetting/HBoxContainer/VolumeHSlider

@onready var auto_play_button : CheckButton = $ScrollContainer/VBoxContainer/AutoPlaySetting/HBoxContainer/CheckButton

# ON/OFF
@onready var auto_play_label : Label = $ScrollContainer/VBoxContainer/AutoPlaySetting/HBoxContainer/TipLabel

@onready var option_1 : OptionButton = $ScrollContainer/VBoxContainer/ColumnSetting1/HBoxContainer/OptionButton1
@onready var option_2 : OptionButton = $ScrollContainer/VBoxContainer/ColumnSetting2/HBoxContainer/OptionButton2
@onready var option_3 : OptionButton = $ScrollContainer/VBoxContainer/ColumnSetting3/HBoxContainer/OptionButton3
@onready var option_4 : OptionButton = $ScrollContainer/VBoxContainer/ColumnSetting4/HBoxContainer/OptionButton4
@onready var option_5 : OptionButton = $ScrollContainer/VBoxContainer/ColumnSetting5/HBoxContainer/OptionButton5
@onready var option_6 : OptionButton = $ScrollContainer/VBoxContainer/ColumnSetting6/HBoxContainer/OptionButton6


var index_map : Dictionary = {"A": 0, "S": 1, "D": 2, "F": 3, "J": 4, "K": 5, "L": 6, ";": 7}

func _ready():
	hesitate_body.visible = Hesitate
	path_body.visible = Path
	speed_body.visible = Speed
	bglight_body.visible = BGLight
	volume_body.visible = Volume
	autoplay_body.visible = AutoPlay
	
	hesitate_spin_box.value = GlobalScene.hesitate_time
	
	speed_slider.value = (GlobalScene.speed - 1100) / 40
	path_line_edit.text = GlobalScene.root_msc_path
	bglight_slider.value = GlobalScene.bglight
	volume_slider.value = GlobalScene.volume
	auto_play_label.text = "ON" if GlobalScene.auto_play else "OFF"
	auto_play_button.button_pressed = GlobalScene.auto_play
	
	
	option_1.select(index_map.get(GlobalScene.key_map["1"]))
	option_2.select(index_map.get(GlobalScene.key_map["2"]))
	option_3.select(index_map.get(GlobalScene.key_map["3"]))
	option_4.select(index_map.get(GlobalScene.key_map["4"]))
	option_5.select(index_map.get(GlobalScene.key_map["5"]))
	option_6.select(index_map.get(GlobalScene.key_map["6"]))


func _on_speed_h_slider_value_changed(value):
	speed_label.text = str(value)
	GlobalScene.speed = 40 * value + 1100


func _on_check_button_toggled(toggled_on):
	auto_play_label.text = "ON" if toggled_on else "OFF"
	GlobalScene.auto_play = toggled_on


func _on_option_button_1_item_selected(index):
	GlobalScene.key_map["1"] = index_map.find_key(index)


func _on_option_button_2_item_selected(index):
	GlobalScene.key_map["2"] = index_map.find_key(index)


func _on_option_button_3_item_selected(index):
	GlobalScene.key_map["3"] = index_map.find_key(index)


func _on_option_button_4_item_selected(index):
	GlobalScene.key_map["4"] = index_map.find_key(index)


func _on_option_button_5_item_selected(index):
	GlobalScene.key_map["5"] = index_map.find_key(index)


func _on_option_button_6_item_selected(index):
	GlobalScene.key_map["6"] = index_map.find_key(index)


func _on_path_line_edit_text_changed(new_text):
	# 检查路径最后是否有 /
	if new_text[-1] != "/" and new_text[-1] != "\\":
		new_text += "/"
	GlobalScene.root_msc_path = new_text
