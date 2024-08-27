extends MarginContainer

@onready var speed_silder : HSlider = $VBoxContainer/NoteSpeedSetting/MarginContainer/HBoxContainer/HBoxContainer/HSlider
@onready var speed_label : Label = $VBoxContainer/NoteSpeedSetting/MarginContainer/HBoxContainer/HBoxContainer/SpeedLabel

@onready var bgLight_silder: HSlider = $VBoxContainer/BGLightSetting/MarginContainer/HBoxContainer/HSlider
@onready var volume_silder: HSlider = $VBoxContainer/VolumeSetting/MarginContainer/HBoxContainer/HSlider

@onready var toggle_button : CheckButton = $VBoxContainer/AutoplaySetting/MarginContainer/HBoxContainer/Button


func _ready():
	speed_silder.value = (RunningData.speed - 15) * 2
	toggle_button.button_pressed = RunningData.is_auto_play
	toggle_button.text = "ON" if toggle_button.button_pressed else "OFF"
	bgLight_silder.value = RunningData.bglight
	volume_silder.value = RunningData.volume


func _on_h_slider_value_changed(value):
	speed_label.text = str(value)
	RunningData.speed = value * 0.5 + 15


func _on_volume_h_slider_value_changed(value: float) -> void:
	RunningData.volume = value


func _on_bgLight_h_slider_value_changed(value: float) -> void:
	RunningData.bglight = value


func _on_button_pressed():
	toggle_button.text = "ON" if toggle_button.button_pressed else "OFF"
	RunningData.is_auto_play = toggle_button.button_pressed
