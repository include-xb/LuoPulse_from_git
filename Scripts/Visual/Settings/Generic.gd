extends MarginContainer

@onready var speed_silder : HSlider = $VBoxContainer/NoteSpeedSetting/MarginContainer/HBoxContainer/VBoxContainer/HSlider
@onready var speed_label : Label = $VBoxContainer/NoteSpeedSetting/MarginContainer/HBoxContainer/VBoxContainer/SpeedLabel

@onready var toggle_button : CheckButton = $VBoxContainer/AutoplaySetting/MarginContainer/HBoxContainer/Button


func _ready():
	speed_silder.value = (RunningData.speed - 15) * 2
	toggle_button.text = "ON" if toggle_button.button_pressed else "OFF"


func _on_h_slider_value_changed(value):
	speed_label.text = str(value)
	RunningData.speed = value * 0.5 + 15


func _on_button_pressed():
	toggle_button.text = "ON" if toggle_button.button_pressed else "OFF"
	RunningData.is_auto_play = toggle_button.button_pressed


# TODO:
# 读写文件记录保存信息
