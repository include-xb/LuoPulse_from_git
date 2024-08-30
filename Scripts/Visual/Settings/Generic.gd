extends MarginContainer

@onready var speed_silder : HSlider = $VBoxContainer/NoteSpeedSetting/MarginContainer/HBoxContainer/HBoxContainer/HSlider
@onready var speed_label : Label = $VBoxContainer/NoteSpeedSetting/MarginContainer/HBoxContainer/HBoxContainer/SpeedLabel

@onready var bgLight_silder: HSlider = $VBoxContainer/BGLightSetting/MarginContainer/HBoxContainer/HSlider
@onready var volume_silder: HSlider = $VBoxContainer/VolumeSetting/MarginContainer/HBoxContainer/HSlider
@onready var user_line_edit: LineEdit = $VBoxContainer/UserNameSetting/MarginContainer/HBoxContainer/LineEdit

func _ready():
	speed_silder.value = (RunningData.speed - 15) * 2
	bgLight_silder.value = RunningData.bglight
	volume_silder.value = RunningData.volume
	user_line_edit.text = RunningData.user_name
	RunningData.temp_user_name = RunningData.user_name

func _on_h_slider_value_changed(value):
	speed_label.text = str(value)
	RunningData.speed = value * 0.5 + 15


func _on_volume_h_slider_value_changed(value: float) -> void:
	RunningData.volume = value


func _on_bgLight_h_slider_value_changed(value: float) -> void:
	RunningData.bglight = value


func _on_line_edit_text_changed(new_text: String) -> void:
	RunningData.temp_user_name = new_text


func _on_line_edit_focus_exited() -> void:
	if RunningData.temp_user_name == "" || RunningData.temp_user_name == null:
		RunningData.temp_user_name = RunningData.user_name
		user_line_edit.text = RunningData.user_name
