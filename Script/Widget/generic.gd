extends MarginContainer


@onready var hesitate_spin_box : SpinBox = $VBoxContainer/HesitateSetting/HBoxContainer/SpinBox

# -20 ~ 20
@onready var speed_label : Label = $VBoxContainer/SpeedSetting/HBoxContainer/VBoxContainer/SpeedLabel

@onready var speed_slider : HSlider = $VBoxContainer/SpeedSetting/HBoxContainer/VBoxContainer/SpeedHSlider

@onready var bglight_slider : HSlider = $VBoxContainer/BGLightSetting/HBoxContainer/BglightHSlider

@onready var volume_slider : HSlider = $VBoxContainer/VolumeSetting/HBoxContainer/VolumeHSlider

@onready var auto_play_button : CheckButton = $VBoxContainer/AutoPlaySetting/HBoxContainer/CheckButton

# ON/OFF
@onready var auto_play_label : Label = $VBoxContainer/AutoPlaySetting/HBoxContainer/TipLabel


func _ready():
	hesitate_spin_box.value = GlobalScene.hesitate_time
	speed_slider.value = (GlobalScene.speed - 1100) / 40
	bglight_slider.value = GlobalScene.bglight
	volume_slider.value = GlobalScene.volume
	auto_play_label.text = "ON" if GlobalScene.auto_play else "OFF"
	auto_play_button.button_pressed = GlobalScene.auto_play


func _on_speed_h_slider_value_changed(value):
	speed_label.text = str(value)
	GlobalScene.speed = 40 * value + 1100


func _on_check_button_toggled(toggled_on):
	auto_play_label.text = "ON" if toggled_on else "OFF"
	GlobalScene.auto_play = toggled_on
