extends MarginContainer

@onready var speed_silder : HSlider = $VBoxContainer/NoteSpeedSetting/MarginContainer/HBoxContainer/VBoxContainer/HSlider
@onready var speed_label : Label = $VBoxContainer/NoteSpeedSetting/MarginContainer/HBoxContainer/VBoxContainer/SpeedLabel

@onready var toggle_button : CheckButton = $VBoxContainer/AutoplaySetting/MarginContainer/HBoxContainer/Button


func _ready():
	toggle_button.text = "ON" if toggle_button.button_pressed else "OFF"


func _on_h_slider_value_changed(value):
	speed_label.text = str(value)


func _on_button_pressed():
	toggle_button.text = "ON" if toggle_button.button_pressed else "OFF"


# TODO:
# 读写文件记录保存信息
